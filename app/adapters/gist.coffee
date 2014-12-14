`import DS from 'ember-data'`

GithubAdapter = DS.RESTAdapter.extend
  host: 'https://api.github.com'

`export default GithubAdapter`
