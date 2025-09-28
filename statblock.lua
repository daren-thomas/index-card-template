-- statblock.lua
-- Detects tables whose header is STAT | SCORE | MOD (| SAVE?) and rewrites them
-- as three adjacent mini tables with two data rows each (MM2025 style).

local stringify = pandoc.utils.stringify

-- Minimal HTML escape (portable across Pandoc versions)
local function h(s)
  s = tostring(s or "")
  s = s:gsub("&", "&amp;")
       :gsub("<", "&lt;")
       :gsub(">", "&gt;")
       :gsub('"', "&quot;")
       :gsub("'", "&#39;")
  return s
end

-- Get text of a Cell across Pandoc versions
local function cell_text(cell)
  if not cell then return "" end
  local blocks = cell.content or cell.contents or cell.blocks
  return stringify(blocks or {})
end

-- Iterate body rows across versions
local function body_rows(tbl_body)
  return (tbl_body and (tbl_body.body or tbl_body.rows)) or {}
end

-- Header check (case-insensitive, trimmed)
local function is_statblock_header(cells)
  local function norm(x) return (x or ""):gsub("^%s+",""):gsub("%s+$",""):lower() end
  local h1 = norm(cell_text(cells and cells[1]))
  local h2 = norm(cell_text(cells and cells[2]))
  local h3 = norm(cell_text(cells and cells[3]))
  return (h1 == "stat" and h2 == "score" and h3 == "mod")
end

-- Render a <table> with given header cell strings and a slice of row cell strings
local function render_table(headers, rows_slice)
  local parts = {}
  table.insert(parts, '<table class="sb-ability"><thead><tr>')
  for _, hh in ipairs(headers) do
    table.insert(parts, '<th>' .. h(hh) .. '</th>')
  end
  table.insert(parts, '</tr></thead><tbody>')
  for _, cells in ipairs(rows_slice) do
    table.insert(parts, '<tr>')
    for i = 1, #headers do
      table.insert(parts, '<td>' .. h(cells[i] or "") .. '</td>')
    end
    table.insert(parts, '</tr>')
  end
  table.insert(parts, '</tbody></table>')
  return table.concat(parts)
end

function Table(tbl)
  -- Header row
  local head = tbl.head
  if not head then return nil end
  local rows = head.rows or head[1] and head[1].rows
  if not (rows and rows[1] and rows[1].cells) then return nil end

  local header_cells = rows[1].cells
  if not is_statblock_header(header_cells) then return nil end

  -- Collect header strings (STAT, SCORE, MOD, optional SAVE)
  local headers = {}
  for i = 1, #header_cells do
    headers[i] = cell_text(header_cells[i])
  end

  -- First body only
  local bodies = tbl.bodies or {}
  local first_body = bodies[1]
  if not first_body then return nil end

  -- Extract body as array of rows; each row -> array of cell strings
  local body = {}
  for _, row in ipairs(body_rows(first_body)) do
    local t = {}
    for i, c in ipairs(row.cells or {}) do
      t[i] = cell_text(c)
    end
    table.insert(body, t)
  end
  if #body == 0 then return nil end

  -- Chunk rows into groups of 2 (2 rows per mini table)
  local chunks = {}
  local i = 1
  while i <= #body do
    local slice = { body[i] }
    if body[i + 1] then table.insert(slice, body[i + 1]) end
    table.insert(chunks, slice)
    i = i + 2
  end

  -- Render up to three mini tables (or more if there are >6 rows; they’ll wrap)
  local html_parts = { '<div class="sb-ability-grid">' }
  for _, slice in ipairs(chunks) do
    table.insert(html_parts, render_table(headers, slice))
  end
  table.insert(html_parts, '</div>')

  return pandoc.RawBlock("html", table.concat(html_parts))
end
