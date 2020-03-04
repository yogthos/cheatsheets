1. create a `package.json`, e.g:

```javascript
{
  "name": "hiccup-template",
  "version": "0.1.2",
  "description": "minimal templating engine using EDN",
  "author": "Dmitri Sotnokov",
  "homepage": "https://github.com/yogthos/hiccup-template",
  "license": "EPL-1.0",
  "directories": {
    "lib": "src"
  },
  "files": [
    "src/*"
  ],
  "keywords": [
    "cljs",
    "EDN",
    "hiccup",
    "template"
  ]
}
```

2. make sure that directory structure follows namespace structure, and use `_` in filenames

3. run `npm pack && npm publish`
