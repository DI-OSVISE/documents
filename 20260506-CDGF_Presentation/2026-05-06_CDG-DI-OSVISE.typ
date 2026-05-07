#import "@preview/polylux:0.4.0": *
#import "@preview/clearly-hm:0.1.1" as hm: *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node, shapes
#import "@preview/cetz:0.5.0": canvas, draw
#import "@preview/tiaoma:0.3.0"

#let osvise-blue = rgb("#011e42")
#let osvise-yellow = rgb("#ffc72c")
#let osvise-red = rgb("#da291c")
#let osvise-green = rgb("#008542")

#let bold-first(word) = {
  if word.len() == 0 { return word }
  text(weight: "bold", word.first()) + word.slice(1)
}

#let bold-initials(phrase) = {
  phrase.split(" ").map(bold-first).join(" ")
}

#let link-github(repo, url: none) = {
  let target = if url != none { url } else { "https://github.com/" + str(repo) }
  link(target)[#box(
    stack(
      dir: ltr,
      spacing: 0.3em,
      image("img/icon-github_invertocat.svg", height: 0.8em),
      text(size: 0.8em, repo),
    ),
  )]
}

#show: hm.setup.with(
  title: "DI-OSVISE",
  subtitle: "Verification of Instruction Set Extensions Made Easy",
  author: "Tobias Wölfel",
  institute: "Hochschule München",
  date: "2026-05-06",
)

#title-slide(content-overlay: {
  bmftr-note()
  place(top + left, dy: 0cm, image("img/logo_di-osvise.svg", width: 10cm))
})

#let bl(fill: luma(90%), body) = block(
  width: 100%,
  fill: fill,
  inset: (x: 1em, y: 0.5em),
  radius: 4pt,
  body,
)


#slide-vertical("Motivation", grid(
  rows: (auto, auto),
  gutter: 1.0em,
  bl(fill: osvise-blue.lighten(90%))[
    - RISC-V drives domain-specific instruction set extensions
    - Instruction generators increase demand for verification
  ],
  bl(fill: osvise-blue.lighten(80%))[
    - Fast evaluation: generators, simulation
    - Investigation of nonfunctional properties: performance, power
    - Verification of new functionalities
  ],
  bl(fill: osvise-yellow.lighten(30%), align(center, text(fill: osvise-blue, [
    #bold-initials("Open Source Verification") of #bold-initials("Instruction Set Extensions")
  ]))),
  bl(fill: osvise-yellow.lighten(70%))[
    #grid(
      columns: (1fr, 1fr),
      [
        - New instruction set descriptions
        - Extending verification capabilities
      ],
      [
        - Built on existing ecosystem
        - Extend open-source tools
      ],
    )
  ],
))

#slide-vertical("Improving Instruction Set Extension Flow", [
  #let core-fill = luma(90%)
  #let highlight-fill = osvise-red.lighten(85%)

  #let x0 = 0mm
  #let x1 = 60mm
  #let x2 = 2 * x1
  #let x3 = 3 * x1
  #let y_top = 64mm
  #let y_mid = 32mm
  #let y_bot = 0mm

  #let diag-style = (
    node-stroke: 0.5pt,
    node-corner-radius: 3pt,
    node-fill: core-fill,
    node-inset: 8pt,
  )

  #align(center)[
    #only(1)[
      #diagram(
        ..diag-style,

        node(
          (x0, y_top),
          [Core Source],
          name: <core-src>,
          fill: luma(97%),
          stroke: stroke(dash: "dashed"),
        ),
        node((x2, y_top), [Extension Specification], name: <ext-spec>),
        node((x0, y_mid), [Core + Extension Source], name: <core-rtl>),
        node((x0, y_bot), [Synthesis &\ Simulation], name: <synth-sim>),

        node(
          (x3, y_bot),
          width: 50mm,
          stroke: none,
          name: <ghost>,
        ),

        edge(<core-src>, <core-rtl>, "->"),
        edge(
          <ext-spec>,
          <core-rtl>,
          "->",
          label: "Generator",
          label-angle: auto,
        ),
        edge(<core-rtl>, <synth-sim>, "->"),
      )
    ]

    #only(2)[
      #diagram(
        ..diag-style,

        // Traditional nodes
        node((x0, y_top), [Core Source], name: <core-src>),
        node((x2, y_top), [Extension Specification], name: <ext-spec>),
        node((x0, y_mid), [Core + ISAX RTL], name: <core-rtl>),
        node((x0, y_bot), [Synthesis &\ Simulation], name: <synth-sim>),

        // New OSVISE nodes (highlighted)
        node(
          (x1, y_mid),
          [Behavior\ Statements],
          name: <behavior>,
          fill: highlight-fill,
        ),
        node(
          (x2, y_mid),
          [ISAX model],
          name: <isax-model>,
          fill: highlight-fill,
        ),
        node(
          (x3, y_mid),
          [Power + Timing\ model],
          name: <power-timing>,
          fill: highlight-fill,
        ),
        node((x1, y_bot), [Verification], name: <verif>, fill: highlight-fill),
        node(
          (x2, y_bot),
          [Co-Simulation],
          name: <co-sim>,
          fill: highlight-fill,
        ),
        node(
          (x3, y_bot),
          [Power Trace],
          name: <power-trace>,
          fill: highlight-fill,
        ),

        // Traditional edges
        edge(<core-src>, <core-rtl>, "->"),
        edge(<ext-spec>, <core-rtl>, "->"),
        edge(<core-rtl>, <synth-sim>, "->"),

        // New OSVISE edges
        edge(<core-src>, <behavior>, "->"),
        edge(<ext-spec>, <behavior>, "->"),
        edge(<ext-spec>, <isax-model>, "->"),
        edge(<ext-spec>, <power-timing>, "->"),
        edge(<behavior>, <verif>, "->"),
        edge(<core-rtl>, <verif>, "->"),
        edge(<behavior>, <co-sim>, "->"),
        edge(<core-rtl>, <co-sim>, "->"),
        edge(<isax-model>, <co-sim>, "->"),
        edge(<power-timing>, <power-trace>, "->"),
      )
    ]
  ]
])

#slide-centered("Tools and Project Partners", [
  #let ns(pos, body, ..args) = node(
    pos,
    width: 4cm,
    fill: osvise-yellow.lighten(70%),
    ..args,
    body,
  )
  #let n(pos, body, ..args) = node(
    pos,
    width: 4cm,
    shape: shapes.pill,
    fill: osvise-green.lighten(80%),
    ..args,
    body,
  )
  #let e(from, to) = edge(from, to, "-|>")
  #diagram(
    node-stroke: 0.5pt + gray,
    node-corner-radius: 4pt,
    node-inset: 8pt,
    edge-stroke: stroke(paint: gray, thickness: 0.15em, dash: (0.25em, 1em)),
    mark-scale: 50%,

    ns((0, 0), [SystemVerilog], name: <systemverilog>),
    ns((1.5, 0), [CoreDSL], name: <coredsl>),

    n((0, 1), [CIRCT], name: <circt>),
    n((1.5, 1), [ETISS], name: <etiss>),
    n((3, 1), [Power], name: <power>),

    n((0, 2), [Yosys], name: <yosys>),
    n((2, 2), [Verilator], name: <verilator>),

    e(<systemverilog>, <circt>),
    e(<coredsl>, <circt>),
    e(<coredsl>, <etiss>),
    e(<coredsl>, <power>),

    e(<circt>, <yosys>),
    e(<circt>, <verilator>),
    e(<etiss>, <verilator>),

    node((0.5, 0.5), fill: white, stroke: none, image(
      "img/logo_hm.svg",
      height: 1.25cm,
    )),
    node((1.5, 0.5), fill: white, stroke: none, image(
      "img/logo_minres.webp",
      height: 1.25cm,
    )),
    node((2.5, 0.5), fill: white, stroke: none, image(
      "img/logo_tuda.svg",
      height: 1.5cm,
    )),
    node(
      (3.5, 0.3),
      fill: white,
      stroke: none,
      image(
        "img/logo_uzl.svg",
        height: 3cm,
      ),
      shape: shapes.rect,
    ),

    node((2.25, 1.25), fill: white, stroke: none, image(
      "img/logo_tuw.svg",
      height: 2cm,
    )),
    node((2.8, 1.5), fill: white, stroke: none, image(
      "img/logo_tum.svg",
      height: 1.5cm,
    )),
    node((1.3, 2), outset: 0pt, inset: 0pt, fill: white, stroke: none, image(
      "img/logo_planv.pdf",
      height: 2.5cm,
    )),
    node((0.7, 1.5), fill: white, stroke: none, image(
      "img/logo_yosys.png",
      height: 1.5cm,
    )),
  )
])

#slide-vertical("Verification Based on Open-Source Ecosystem", [
  - *Objective*: Generate verification statements based on the instruction
    extension specification
  - *Flow*: CoreDSL specification #sym.arrow.r SystemVerilog Assertions

  #align(center)[
    #diagram(
      node-stroke: 1pt,
      node-shape: rect,
      spacing: 2em,
      node(
        (1, 0),
        [CoreDSL],
        fill: osvise-green.lighten(80%),
        shape: shapes.pill,
        name: <coredsl>,
      ),
      node(
        (2, 0),
        [CoreDSL\ Dialect],
        name: <shortnail>,
      ),
      node(
        (3, 0),
        [Conversion],
        fill: osvise-red.lighten(80%),
        name: <conversion>,
      ),
      node(
        (4, 0),
        [Core\ Dialects],
        name: <core>,
      ),
      node(
        (5, 0),
        [Verilog\ export],
        name: <verilog>,
      ),
      node(
        (3.5, -0.75),
        [CIRCT],
        stroke: none,
        name: <label-circt>,
      ),
      node(
        enclose: (<shortnail>, <conversion>, <core>, <verilog>),
        fill: none,
        stroke: stroke(dash: "dotted"),
        height: 3cm,
        name: <circt>,
      ),
      node(
        (6, 0),
        [SystemVerilog\ Assertions],
        fill: osvise-green.lighten(80%),
        shape: shapes.pill,
        name: <sva>,
      ),
      edge(<coredsl>, <circt>, "-|>"),
      edge(<circt>, <sva>, "-|>"),
      edge(<shortnail>, <conversion>, "--|>"),
      edge(<conversion>, <core>, "--|>"),
      edge(<core>, <verilog>, "--|>"),
    )]

  - *Reuse* of existing infrastructure: CoreDSL specification, CIRCT compiler
  - Focus on new conversion pass to *extract* verification statements from
    behavior
  - Open-source ecosystem facilitates complex flow and enables advanced
    automatic verification statements
])

#slide-vertical("Benefiting from Evolving Open-Source EDA", [

  #grid(
    columns: (1fr, auto),
    gutter: 1em,
    [
      *Leverage* existing open-source ecosystem for complex and *novel* design
      flows.
      - *Chosys*: Start with a Hardware Description Language (Chisel) and
        output a netlist.
        - No Verilog needed
        - Enables transportation of additional information
        - Focus on new dialects and passes
      - Verification based on Linear Temporal Logic for extended SystemVerilog
        Assertions support
      #block(
        fill: osvise-yellow.lighten(70%),
        inset: (x: 1em, y: 0.5em),
        radius: 0.5em,
        [Extending existing ecosystem enables further advancements, allows for
          faster research and more capable tools.],
      )
    ],
    diagram(
      node-stroke: 1pt,
      node-shape: rect,
      node-fill: white,
      spacing: 1em,

      node((0, 0), [Chisel], name: <chisel>, shape: shapes.pill),
      node((1, 0), [CoreDSL], name: <coredsl>, shape: shapes.pill),

      node((0, 2), [Core\ Dialects], name: <core>, fill: none),
      node((1, 2), [LTL], name: <ltl>),
      node((2, 2), [CIRCT], name: <label-circt>, stroke: none),

      node(
        enclose: (
          <core>,
          <ltl>,
          <label-circt>,
        ),
        stroke: stroke(dash: "dotted"),
        fill: none,
        name: <circt>,
      ),

      node(
        (0, 4),
        [RTLIL],
        fill: none,
        name: <yosys-rtlil>,
      ),
      node((1, 4), [Properties], name: <yosys-pir>),
      node((2, 4), [Yosys], stroke: none, name: <lable-yosys>),

      node(
        enclose: (<yosys-rtlil>, <yosys-pir>, <lable-yosys>),
        stroke: stroke(dash: "dotted"),
        fill: none,
        name: <yosys>,
      ),

      node((1, 6), [Netlist], name: <netlist>),

      edge(
        <chisel>,
        <core>,
        "->",
        stroke: osvise-green + 3pt,
        mark-scale: 30%,
      ),
      edge(
        <chisel>,
        <ltl>,
        "->",
        stroke: osvise-red + 1.5pt,
        mark-scale: 30%,
      ),
      edge(<core>, <yosys>, "->", stroke: osvise-green + 3pt, mark-scale: 30%),
      edge(
        <yosys>,
        <netlist>,
        "->",
        stroke: osvise-green + 3pt,
        mark-scale: 30%,
      ),
      edge(
        (2, 6),
        (rel: (1, 0)),
        label: "Chosys",
        label-sep: 0pt,
        "-",
        stroke: osvise-green + 3pt,
        mark-scale: 30%,
      ),

      edge(<coredsl>, <ltl>, "->", stroke: osvise-red + 3pt, mark-scale: 30%),
      edge(<ltl>, <yosys-pir>, "->", stroke: osvise-red + 3pt, mark-scale: 30%),
      edge(
        <yosys-pir>,
        <yosys-rtlil>,
        "<->",
        shift: 4pt,
        stroke: osvise-red + 3pt,
        mark-scale: 30%,
      ),

      edge(
        (2, 7),
        (rel: (1, 0)),
        label: "SVA",
        label-sep: 0pt,
        "-",
        stroke: osvise-red + 3pt,
        mark-scale: 30%,
      ),
    ),
  )])

#let add-explanation(
  target,
  pos,
  marker-stroke: stroke(paint: gray, thickness: 1.5pt, dash: "dashed"),
  label-fill: luma(90%),
  label-stroke: stroke(paint: luma(30%), thickness: 1pt),
  label-anchor: "west",
  body,
) = {
  // Draw the arrow
  draw.line(
    pos,
    target,
    mark: (end: "o", scale: 5, stroke: osvise-red + 2pt),
    stroke: marker-stroke,
  )

  draw.content(
    pos,
    rect(
      text(size: 10pt, body),
      stroke: label-stroke,
      fill: label-fill,
      radius: 4pt,
      inset: (x: 1em, y: 0.3em),
    ),
    anchor: label-anchor,
  )
}

#slide-centered("Impact Open-Source Development", [
  #align(center)[
    #canvas({
      import draw: *

      content((0, 0), name: "img", image(
        "img/osvise-overview.drawio.pdf",
        height: 10cm,
      ))

      add-explanation(
        (3.4, 2.1),
        (9, 3),
        link-github("Minres/CRIG"),
        label-fill: osvise-blue.lighten(70%),
      )
      add-explanation(
        (5, 3.7),
        (9, 4),
        link-github("tum-ei-eda/isaac-perf-gen"),
        label-fill: osvise-blue.lighten(70%),
      )

      add-explanation(
        (5, 0),
        (9, 1),
        link-github(
          [tum-ei-eda/\ PerformanceSimulation\ \_workspace],
          url: "https://github.com/tum-ei-eda/PerformanceSimulation_workspace",
        ),
        label-fill: osvise-blue.lighten(70%),
      )
      add-explanation(
        (3.2, -1.5),
        (9, -1),
        link-github("tum-ei-eda/etiss"),
        label-fill: osvise-green.lighten(80%),
      )

      add-explanation(
        (6.3, -2.8),
        (9, -3),
        link-github("iti-luebeck/sca-wal"),
        label-fill: osvise-blue.lighten(70%),
      )

      add-explanation(
        (3.8, -3.4),
        (9, -5),
        link-github(
          [planvtech/\ PlanV_Verilator_Feature_Tests],
          url: "planvtech/PlanV_Verilator_Feature_Tests",
        ),
        label-fill: osvise-blue.lighten(70%),
      )

      add-explanation(
        (-0.6, 2.8),
        (-12, 4),
        link-github("hm-aemy/coredsl-to-sva"),
        label-fill: osvise-blue.lighten(70%),
      )
      add-explanation(
        (-1, 2),
        (-12, 2.5),
        link-github("hm-aemy/Shortnail"),
        label-stroke: luma(50%) + 0.5pt,
        label-fill: osvise-blue.lighten(80%),
      )
      add-explanation(
        (0, 3),
        (-12, 3),
        link-github("esa-tu-darmstadt/Shortnail"),
        label-fill: osvise-green.lighten(80%),
      )

      add-explanation(
        (-4.5, 2.2),
        (-12, 1.5),
        link-github("hm-aemy/chosys"),
        label-fill: osvise-blue.lighten(70%),
      )
      add-explanation(
        (-5, 0),
        (-12, 0),
        link-github("llvm/circt"),
        label-fill: osvise-green.lighten(80%),
      )
      add-explanation(
        (-1.5, -2),
        (-12, -1),
        link-github("verilator/verilator"),
        label-fill: osvise-green.lighten(80%),
      )
      add-explanation(
        (-6.3, -1.9),
        (-12, -3),
        link-github("YosysHQ/yosys"),
        label-fill: osvise-green.lighten(80%),
      )
      add-explanation(
        (-6.0, -2.1),
        (-12, -5),
        link-github("YosysHQ/property-ir"),
        label-fill: osvise-blue.lighten(70%),
      )
    })
    #only(2)[
      #place(center + horizon)[
        #block(
          fill: luma(95%),
          stroke: black + 3pt,
          radius: 10pt,
          inset: (x: 3em, y: 2em),
          align(left, [
            - Development is done in the open
              - Instant feedback
              - Motivation for higher quality and reusability
            - Enables outside collaboration
              - Higher impact by working with the community
            - Continuous improvements and direct availability
          ]),
        )
      ]
    ]
  ]
])

#slide-vertical("OSVISE Upcoming Conference Participation", grid(
  columns: (3fr, 1fr, 1fr),

  [
    Save the date for the leading open-source silicon conference
    - *ORConf 2026*
      - September 11 to 13
      - Ghent, Belgium
    - Meet the community
    - Free to attend!

    - Co-located with FPL
  ],

  image("img/logo_fossi.svg", width: 4cm),

  tiaoma.qrcode(
    width: 4cm,
    "https://fossi-foundation.org/orconf/2026",
    options: (fg-color: black, dot-size: 1.1),
  ),
))


#slide()[
  #grid(
    columns: (1fr, 2fr, 1fr),
    rows: (2fr, 1fr),
    align: center + horizon,
    gutter: 2em,
    stroke: (x, y) => if x > 0 and y == 0 { (left: 1pt + osvise-blue) },
    align(center, [
      #image("img/poster-OSVISE-CDGF-2026.pdf", height: 7cm)
      #text(fill: osvise-blue)[Visit our poster]
    ]),
    [
      #image("img/logo_di-osvise.svg", height: 2cm)
      #v(5em)
      #block(fill: osvise-blue, inset: 1em, radius: 0.5em, text(
        fill: osvise-yellow,
        size: 28pt,
        weight: "bold",
      )[Thank you!])
    ],
    align(center + horizon)[
      #tiaoma.qrcode(height: 4cm, "https://di-osvise.github.io", options: (
        fg-color: osvise-blue,
        dot-size: 1.1,
        output-options: (barcode-dotty-mode: true),
      ))
      #text(fill: osvise-blue)[#link(
        "di-osvise.github.io",
      )[di-osvise.github.io]]
    ],

    [],
    text(size: 10pt)[Supported by the German Federal Ministry of
      Research, Technology and Space in the
      project ”DI-OSVISE” (grant: 16ME0953K).],
    bmftr-note(dx: 0cm, dy: 0cm),
  )
]
