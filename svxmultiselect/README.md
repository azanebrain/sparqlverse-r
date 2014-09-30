# Explanation

Description: This project offers the ability to select any playground example.

The UI defines the different options which are evaluated in `server.R`. For example, if the chosen example has a `limit` operator, the UI will update to have the appropriate components.

## Run
For development, you will need serve the Shiny Server, and watch for file changes.
```
npm run serve
npm run watch
```

## Setup 
- Make a copy of `endpoint.txt.sample` named `endpoint.txt` and set the endpoint for SVX.
- `npm install`

### Dependencies
- NPM
- Ruby
- Sass