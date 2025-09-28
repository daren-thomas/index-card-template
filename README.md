# index-card-template
A template for printing Index cards from Obsidian using the [Enhancing Export Plugin](https://github.com/mokeyish/obsidian-enhancing-export).

## Prerequisits

- the template files in this repository
  - `statblock.lua`
  - `two-column-index-cards.css`
  - `two-column-index-cards.html`
- the paged.js `interface.css` file, download it from here: https://gitlab.coko.foundation/pagedjs/interface-polyfill
- you need the Enhancing Export Plugin installed. Search "obsidian-enhancing-export" in the community plugins of obsidian, and install it.
- you need `pandoc` installed. See https://pandoc.org/installing.html for more information on how to install it on your system. The plugin needs to be able to access `pandoc`.

Go to the root folder of your Obsidian vault, navigate to the folder `.obsidian` and create a new folder in there called `two-column-index-cards`. Place the template files and the `interface.css` files into that folder. If you want to place these files somewhere else, update the template arguments below accordingly.

 
## Configuring the Export

- in Obsidian, go to the settings page and choose "Export Settings" under "Community Plugins". This let's you configure the Enhancing Export Plugin.
- add a template
  - choose "Html"
  - give it a name (e.g. "Index Cards")
- set the arguments to something like this:

```
-f ${fromFormat} --resource-path="${vaultDir}/.obsidian/two-column-index-cards}" --resource-path="${attachmentFolderPath}" --embed-resources --standalone --metadata title="${currentFileName}" -s -o "${outputPath}" --css="two-column-index-cards.css" --template="two-column-index-cards.html" --section-divs --lua-filter="${vaultDir}/.obsidian/two-column-index-cards/statblock.lua" -t html
```

These are `pandoc` arguments that will be fed directly to `pandoc`. You can look up their meaning in the [pandoc manual](https://pandoc.org/MANUAL.html). What the Enhancing Export plugin does is replace certain variables inside that string with information provided by Obsidian. You can find out the list of variables here: https://github.com/mokeyish/obsidian-enhancing-export?tab=readme-ov-file#variables



## License information

The actual template files are under the CC0 1.0 Universal license provided in this Repository.

The examples contain information from other sources and are licensed as such:

- Information from the SRD 5.2 is licensed under [CC-BY-4.0 license](https://creativecommons.org/licenses/by/4.0/)
- In particular, I'm using Markdown formatted by Sly Flourish in his **5e Artisanal Database**. You should definitely consider joining the [Sly Flourish Patreon](https://www.patreon.com/cw/slyflourish) to get access to this excellent tool and so much more!
- Original inspiration for the template comes from the Patchwork Paladin blog post [Pretty printing in Obsidian](https://patchworkpaladin.com/2025/05/26/pretty-printing-in-obsidian/)
