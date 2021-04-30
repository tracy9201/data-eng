# Looker Customized Visualization in React

Create customized visualization components that are host within looker application.

### Usage

To develop and test customized visualization in Looker locally, it requires host visulization over https and create a manifest with a "Main" file pointing at your IP address and hosting port.

```bash
$ pip install pyhttps # to install a simple https server required by Looker.
```
To install and run the project in local host.

```bash
$ yarn # install node_modules after clone the repo
$ yarn build # generate dist folder and build JS files to be host in Looker application
$ yarn dev # start server for development in Looker
```
- Server host and port can be changed at `settings.js` at project root.


In Looker, navigate to the Admin page, and select "Visualizations" in the "Platform".

Click "Add Visualization" to create a new manifest.

Add a unique id, a label for your visualization components (suggestion: prefixing it with DEV ONLY so no one creates and saves content with it).

Finally, the "Main" file should point at https://localhost:4443/[component namne].js.

### Create New Vis Components and Build JS File in Dist Folder

Go to `client-config.js` within webpack folder.
```bash
  # create variable to point at the right path, take below as example
  const table = ['./src/components/table/index.js']
  const stmt = ['./src/components/statement/index.js']
  const string = ['./src/components/string/index.js']

  # and go to entry to fill up the path map
  entry: {
      table: table,
      stmt: stmt,
      string: string,
  },

  # then run $ yarn build again to create new built JS files to be linked in Looker application
```


### Tech Stack

- React
- Webpack
- Babel
- ESLint
- Prettier
- Jest
- React Testing Library
- Looker API for customized visualization


### Commands

- `yarn start` - Start server for development
- `yarn build` - Build production bundle and host to Looker application
- `yarn dev` - Serve local files with https and watch local file changes
- `yarn test` - Start running tests
- `yarn cov` - Start running tests with coverage report
- `yarn lint` - Start eslint validation and do auto-fix
- `yarn analysis` - Analyze the size of each module


### Additional Resources
- [Get started customized visualization in Looker ](https://github.com/looker/custom_visualizations_v2/blob/master/docs/getting_started.md)
- [API 2.0 Reference](https://github.com/looker/custom_visualizations_v2/blob/master/docs/api_reference.md)
- [Presenting Configuration UI (parameters options)](https://github.com/looker/custom_visualizations_v2/blob/master/docs/api_reference.md#presenting-configuration-ui)
