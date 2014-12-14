`import DS from 'ember-data'`

Gist = DS.Model.extend
  title: DS.attr 'string'
  src: DS.attr 'string'
  tests: DS.attr 'string'

`export default Gist`
