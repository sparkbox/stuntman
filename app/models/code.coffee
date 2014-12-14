`import DS from 'ember-data'`

attr = DS.attr

Code = DS.Model.extend
  source: attr 'string'
  tests: attr 'string'

`export default Code`
