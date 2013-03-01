//= require active_admin/base
//= require jquery.bobbograph

bb_options = {
  height: 200,
  line_width: 5,
  duration: 500,
  smooth_graph: true,
  peaks_and_valleys: false,
  bevel: true,
  dividers: [ { count: 25, line_width: 0.5 }, { count: 5, line_width: 1.5 } ],
  fill: [ 'rgba(0, 204, 255, 0.25)', 'rgba(0, 204, 255, 0)' ],
  fill: [
      'rgba(' + [ 0xff, 0xcc, 0, 0.25 ] + ')',
      'rgba(' + [ 0, 0xcc, 0xff, 0.25 ] + ')'
  ],
  color: [ '#fc0', '#0cf' ]
}