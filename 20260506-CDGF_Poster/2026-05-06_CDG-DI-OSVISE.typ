#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node, shapes
#import "@preview/tiaoma:0.3.0"

// =============================================================================
// Page setup
// =============================================================================

// Colors
#let palette = (
  primary: rgb("#011e42"),
  secondary: rgb("#4a5c78"),

  osvise-yellow: rgb("#ffc72c"),

  // Accent Colors
  green: rgb("#2D8A4E"),
  yellow: rgb("#B8860B"),
  red: rgb("#C0392B"),
  blue: rgb("#2980B9"),
  teal: rgb("#16A085"),
  orange: rgb("#D35400"),
  purple: rgb("#8E44AD"),

  // Grays & Neutrals
  dark-gray: rgb("#2c3e50"),
  mid-gray: luma(60%),
  light-gray: luma(94%),
  off-white: luma(98%),
)
#let style = (
  fill-heading: palette.primary,
  fill-card-bg: palette.off-white,
  fill-card-header: palette.light-gray,
  fill-highlight-soft: palette.blue.lighten(90%),
  fill-highlight-vibrant: palette.blue.lighten(70%),
  fill-accent-box: palette.light-gray.darken(2%),
  stroke-muted: 1pt + palette.mid-gray,
)

// Styling
#set page(
  paper: "a0",
  margin: 25mm,
)
#set text(font: "Inter", size: 28pt)
#set par(justify: true, leading: 0.65em)
#show heading.where(level: 1): it => text(
  fill: style.fill-heading,
  weight: "bold",
  size: 38pt,
  it.body,
)
#show heading.where(level: 2): it => text(
  fill: style.fill-heading,
  weight: "bold",
  size: 32pt,
  it.body,
)

// Building block
#let card(
  title,
  heading-fill: white,
  body-fill: style.fill-card-bg,
  body,
) = block(
  width: 100%,
  height: 100%,
  stroke: 2pt + luma(60%),
  radius: (top: 30pt),
  clip: true,
  grid(
    rows: (auto, 1fr),
    block(
      width: 100%,
      fill: heading-fill,
      inset: (x: 1em, y: 0.8em),
      [= #title],
    ),
    block(
      width: 100%,
      height: 100%,
      fill: gradient.linear(
        body-fill,
        body-fill.lighten(50%),
        dir: ttb,
      ),
      inset: 1em,
      body,
    ),
  ),
)

#let highlight-box(
  fill: palette.yellow.lighten(80%),
  stroke: none,
  radius: 4pt,
  inset: 10pt,
  body,
) = block(
  width: 100%,
  fill: fill,
  stroke: stroke,
  radius: radius,
  inset: inset,
  body,
)

#let result-box(
  title: "Results",
  fill: palette.green.lighten(80%),
  dir: ttb,
  text-color: auto,
  body,
) = block(
  fill: fill,
  stroke: 4pt + fill.darken(30%),
  outset: 10pt,
  inset: 10pt,
  radius: 10pt,
  width: 100%,
  [
    #let t = if title != none and title.len() > 0 { [*#title:*] }
    #set text(fill: if text-color != auto { text-color } else if fill
      .luma()
      .components()
      .at(0)
      < 50% { white } else { black })
    #stack(
      dir: dir,
      spacing: if title != none and title.len() > 0 { 0.5em },
      [*#t*],
      body,
    )
  ],
)

#let link-github(repo) = {
  link("https://github.com/" + repo)[#box(image(
      "img/icon-github_invertocat.svg",
      height: 0.8em,
    ))#h(0.2em)#repo]
}

// =============================================================================
// Page layout
// =============================================================================

#let poster(
  header,
  overview,
  isntr_stream,
  coreperf,
  nonfunctional,
  functional,
  impact,
  scoreboard,
  footer,
) = {
  grid(
    // The second row (footer) gets the space it needs.
    // The remaining part above it, is for the rest of the page.
    rows: (1fr, auto),
    row-gutter: 0.5cm,
    [
      // Split between title and main content
      // Title gets the space it needs with `auto`.
      // The remaining space for the main content.
      #grid(
        rows: (auto, 1fr),
        row-gutter: 3cm,
        [
          #header
        ],
        [
          // Main content
          // card 1-7
          #grid(
            columns: (4fr, 5fr, 4fr),
            rows: (0.9fr, 1.2fr, 1.0fr, 1.0fr),
            column-gutter: 1em,
            row-gutter: 1em,

            // Row 1
            grid.cell(colspan: 3, rowspan: 1, overview),

            // Row 2
            grid.cell(colspan: 1, rowspan: 1, isntr_stream),
            grid.cell(colspan: 1, rowspan: 1, coreperf),
            grid.cell(colspan: 1, rowspan: 4, nonfunctional),

            // Row 3
            grid.cell(colspan: 1, rowspan: 1, scoreboard),
            grid.cell(colspan: 1, rowspan: 3, functional),
            grid.cell(colspan: 1, rowspan: 2, impact),
          )
        ],
      )
    ],
    [
      #footer
    ],
  )
}

// =============================================================================
// Content
// =============================================================================

// Header
#let header = block(
  width: 100%,
  fill: white,
  radius: (top: 5pt, bottom: 0pt),
  inset: (x: 20pt, y: 14pt),
  grid(
    columns: (auto, auto),
    align: center + horizon,
    column-gutter: 4cm,
    image("img/logo_di-osvise.svg", width: 24cm),
    align(center)[
      #text(fill: palette.primary, weight: "medium", size: 90pt)[
        Open Source Verification of\ Instruction Set Extensions
      ]
    ],
  ),
)

// Overview
#let card_overview = card(
  "Overview",
  grid(
    columns: (3fr, 3fr),
    gutter: 1em,
    [
      OSVISE is motivated by the need for open-source tools for verification of
      instruction set extensions. RISC-V enables frictionless instruction set
      extensions. This requires an ecosystem which supports fast evaluation,
      verification, and investigation of nonfunctional properties.

      The OSVISE project focuses on closing the gaps in the open-source
      EDA ecosystem when working on Instruction Set Extensions.
      Central to this tool stacks are: *CIRCT*, *Yosys*, *Verilator*, *ETISS*, *CoreDSL*.

    ],
    [
      #align(center)[#block(stroke: 2pt + palette.dark-gray, inset: 0.5cm)[
        #show: text.with(size: 22pt)
        #let node-style-traditional = ()
        #let node-style-osvise = (fill: palette.green.lighten(80%))
        #diagram(
          node-stroke: 1pt,
          node-corner-radius: 3pt,
          node-fill: white,
          node-inset: 8pt,
          spacing: (1em, 2em),

          // Traditional nodes
          node(
            (0, 0),
            [Core Source],
            name: <core-src>,
            ..node-style-traditional,
          ),
          node(
            (1.5, 0),
            [Extension Specification],
            name: <ext-spec>,
            ..node-style-traditional,
          ),
          node(
            (0, 1),
            [Core + Extension RTL],
            name: <core-rtl>,
            ..node-style-traditional,
          ),
          node(
            (0, 2),
            [Synthesis &\ Simulation],
            name: <synth-sim>,
            ..node-style-traditional,
          ),

          // New OSVISE nodes (highlighted)
          node(
            (1, 1),
            [Behavior\ Statements],
            name: <behavior>,
            ..node-style-osvise,
          ),
          node(
            (2, 1),
            [ISAX model],
            name: <isax-model>,
            ..node-style-osvise,
          ),
          node(
            (3, 1),
            [Power + Timing\ model],
            name: <power-timing>,
            ..node-style-osvise,
          ),
          node(
            (1, 2),
            [Verification],
            name: <verif>,
            ..node-style-osvise,
          ),
          node(
            (2, 2),
            [Co-Simulation],
            name: <co-sim>,
            ..node-style-osvise,
          ),
          node(
            (3, 2),
            [Power Trace],
            name: <power-trace>,
            ..node-style-osvise,
          ),

          node(
            (2.7, 2.8),
            text(size: 10pt)[Existing flow],
          ),
          node(
            (3.3, 2.8),
            text(size: 10pt)[OSVISE additions],
            ..node-style-osvise,
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
          edge(<core-rtl>, <co-sim>, "->"),
          edge(<isax-model>, <co-sim>, "->"),
          edge(<power-timing>, <power-trace>, "->"),
        )
      ]]],
  ),
)

// Instruction Stream
#let card_instr_stream = card(
  "Instruction Stream",
  heading-fill: palette.orange.lighten(85%),
  body-fill: palette.orange.lighten(95%),
  grid(
    rows: (1fr, auto),
    gutter: 2em,
    align: top + left,
    [*Instruction Stream Generator*:
      - Architectural-aware instruction stream for checks across multiple instructions
      - Specification of constraints to describe architecture
      - ISAX specified in CoreDSL
    ],
    result-box(title: "Status", dir: ltr)[
      - Specification completed
      - Prototype implemented
    ],
  ),
)

// Performance Modeling
#let card_coreperf = card(
  "Performance Modeling",
  heading-fill: palette.blue.lighten(85%),
  body-fill: palette.blue.lighten(95%),
  grid(
    rows: (1fr, auto),
    gutter: 2em,
    align: top + left,
    [*CorePerfDSL Generator:*
      - Reuses ISAX generator flow output
      - Integrates into ETISS simulators for precise performance estimates
    ],

    align(center)[
      #show: text.with(size: 20pt)
      #diagram(
        node-stroke: 1pt,
        node-corner-radius: 3pt,
        node-fill: white,
        node-inset: 8pt,
        spacing: (2em, 2em),
        node((0, -0.5), [CoreDSL], name: <coredsl>),
        node((1, -0.5), [Schedule\ (HLS Flow)], name: <schedule>),
        node((0.5, 0.5), [CorePerfDSL], name: <coreperf>),
        node((2, 0), [ISAX\ Generator], name: <generator>),
        node((3, 0), [CorePerfDSL\ ISAX], name: <coreperfdsl>),
        node((4, 0), [ETISS\ PerfSim], name: <etiss>),
        edge(<coredsl>, <schedule>, "-|>"),
        edge(<schedule.east>, <generator>, "-|>", bend: 0deg),
        edge(<coreperf.east>, <generator>, "-|>", bend: -0deg),
        edge(<generator>, <coreperfdsl>, "-|>"),
        edge(<coreperfdsl>, <etiss>, "-|>"),
      )
    ],
    result-box(title: "Status", dir: ltr)[
      - Specification completed
      - Prototype implemented
    ],
  ),
)

// Nonfunctional Verification
#let card_nonfunctional = card(
  "Nonfunctional Verification",
  heading-fill: palette.yellow.lighten(85%),
  body-fill: palette.yellow.lighten(95%),
  grid(
    rows: (1fr, auto),
    gutter: 2em,
    [
      *Extendable Translating Instruction Set Simulator (ETISS) with Performance Estimation*:
      - Demonstrates high-level simulation feasibility using Co-Simulation
      - Enables rapid performance and energy evaluation
      - Estimates performance and energy of generated instruction streams using the core's average power
    ],
    align(center)[
      #show: text.with(size: 20pt)
      #diagram(
        node-stroke: 1pt,
        node-corner-radius: 3pt,
        node-fill: white,
        node-inset: 8pt,
        spacing: (1em, 2em),
        node((0.5, -1), [Benchmark Executable], name: <input>),
        node((0, 0), [], name: <top-l>),
        node((0, 1), [GL-Sim], name: <glsim>),
        node((0, 1.5), [Syn PP], name: <synpp>),
        node((1, 0), [], name: <top>),
        node(
          enclose: (<top-l>, <glsim>, <synpp>),
          stroke: stroke(dash: "dotted"),
          align(top + left)[Ground-Truth\ Flow],
          name: <ground>,
        ),
        node(
          (0, 2.25),
          align(left)[Performance &\ Energy Values],
          name: <orig-trace>,
        ),
        node(
          (1, 1),
          align(left)[Performance\ EstimatorPlugin\ +Energy-Estimate],
          name: <plugin>,
        ),
        node(
          enclose: (<top>, <plugin>),
          stroke: stroke(dash: "dotted"),
          align(top + left)[ETISS],
          name: <etiss>,
        ),
        node(
          (1, 2.25),
          align(left)[Performance &\ Energy Values],
          name: <trace>,
        ),
        edge(<input>, "-|>", <ground>),
        edge(<input>, "-|>", <etiss>),
        edge(<etiss>, "-|>", <trace>),
        edge(<ground>, "-|>", <orig-trace>),
        edge(
          <orig-trace.south>,
          <trace.south>,
          kind: "arc",
          bend: -30deg,
          stroke: palette.dark-gray,
          "-|>",
          label: text(
            size: 18pt,
            fill: palette.dark-gray,
          )[\~100 k execution\ time speed-up],
          label-anchor: "north",
        ),
      )],
    [
      *Power Estimation*:
      - Power estimation based on switching activity extracted from VCDs
      - Waveform parsing using the open-source Waveform Analysis Language (WAL)
      - Uses Liberty files for hardware parameters and netlists for gate-level analysis
    ],
    align(center)[
      #show: text.with(size: 20pt)
      #diagram(
        node-stroke: 1pt,
        node-corner-radius: 3pt,
        node-fill: white,
        node-inset: 8pt,
        spacing: (1em, 2em),
        node((0, -2), [Design], name: <design>),
        node((1, -2), [Testbench], name: <testbench>),
        node((0, -1), [Simulation], name: <simulation>),
        node(
          (1, -0.5),
          [Input Test\ Patterns],
          name: <patterns>,
          shape: shapes.pill,
        ),
        node((-1.5, 0), [], name: <empty>),
        node((0, 0), [VCD], name: <vcd>, shape: shapes.pill),
        node(
          (-1, 1),
          [SCA-WAL\ Framework],
          stroke: none,
          fill: none,
          name: <sca>,
        ),
        node((0, 1), [Analysis], name: <analysis>),
        node((0, 2), [Trace], name: <trace>, shape: shapes.pill),
        node(
          enclose: (<empty>, <vcd>, <analysis>, <trace>, <sca>),
          stroke: stroke(dash: "dotted"),
        ),
        node((0, 3), [TVLA Report], name: <tvla>, shape: shapes.pill),
        node((1, 3), [CPA Results], name: <cpa>, shape: shapes.pill),

        edge(<patterns>, <testbench>, "-|>"),
        edge(<testbench>, <simulation>, "-|>"),
        edge(<design>, <simulation>, "-|>"),
        edge(<simulation>, <vcd>, "-|>"),
        edge(<vcd>, <trace>, "-|>"),
        edge(<trace>, <tvla>, "-|>"),
        edge(<trace>, <cpa>, "-|>"),
        edge(
          <patterns>,
          <cpa>,
          "--|>",
          stroke: palette.dark-gray,
          label: text(size: 18pt, fill: palette.dark-gray, "Verify"),
          label-side: left,
        ),
      )],
    result-box(title: "Status", dir: ttb)[
      - Demonstration for RISC-V dotprod ISAX
      - CorePerfDSL Generator for ISAX
      - Power estimation and modeling methods survey
      - Open-source analytical power estimation model for RTL and gate-level
    ],
  ),
)

// Functional Verification (CIRCT)
#let card_functional = card(
  "Functional Verification",
  heading-fill: palette.teal.lighten(85%),
  body-fill: palette.teal.lighten(95%),
  grid(
    rows: (1fr, auto),
    gutter: 2em,
    [
      *SystemVerilog Assertions*:
      - Hardware verification is crucial, yet open-source tooling remains
        limited
      - OSVISE extends open-source support for concurrent assertions
      - CIRCT acts as a central hub, mapping diverse inputs to central _core_
        dialects via specific conversions

    ],
    align(center)[
      #show: text.with(size: 20pt)
      #diagram(
        node-stroke: 1pt,
        node-corner-radius: 3pt,
        node-fill: white,
        node-inset: 8pt,
        spacing: (1em, 2em),
        node((1, 0), [CoreDSL], name: <coredsl>),
        node((1, 1), [Treenail], name: <treenail>, shape: shapes.pill),
        node((2, 0), [SystemVerilog], name: <sv>),
        node((1, 2), [Shortnail], name: <shortnail>),
        node((2, 2), [Slang], name: <slang>),
        node((2, 3), [Moore], name: <moore>),
        node((1, 4), [LTL], name: <ltl>),
        node((1.75, 4.25), [Comb], name: <comb>),
        node((2.25, 4.25), [HW], name: <hw>),
        node((2.75, 4.25), [Seq], name: <seq>),
        node((4, 4), [Verif], name: <verif>),
        node((1, 5), [RTLIL], name: <rtlil>),
        node((2, 5), [PIR], name: <pir>),
        node(
          enclose: (<shortnail>, <slang>, <verif>, <rtlil>),
          stroke: stroke(dash: "dotted"),
          inset: 1em,
          align(top + right)[CIRCT],
          name: <circt>,
        ),
        node((2.5, 3.5), [], name: <coretxt>),
        node(
          enclose: (<comb>, <seq>, <coretxt>),
          fill: white,
          stroke: stroke(dash: "dotted"),
          align(top + right)[Core],
          name: <core>,
        ),
        node((1, 6.5), [RTLIL], name: <ys-rtlil>),
        node((2, 6.5), [Property IR], name: <ys-pir>),
        node(
          (2.9, 6.5),
          [Yosys],
          width: 5em,
          stroke: none,
          fill: none,
          name: <ystxt>,
        ),
        node(
          enclose: (<ys-rtlil>, <ys-pir>, <ystxt>),
          stroke: stroke(dash: "dotted"),
          inset: 1em,
          name: <yosys>,
        ),
        node((4, 6.5), [Verilator], name: <verilator>),

        edge(<coredsl>, <treenail>, "-|>"),
        edge(<treenail>, <shortnail>, "<|--|>"),
        edge(<sv>, <slang>, "-|>"),

        edge(<slang>, <moore>, "-|>"),

        edge(<shortnail>, <core>, "-|>"),
        edge(<shortnail>, <verif>, "-|>", bend: 20deg),
        edge(<shortnail>, <ltl>, "-|>"),

        edge(<moore>, <core>, "-|>"),
        edge(<moore>, <verif>, "-|>", bend: 15deg),
        edge(<moore>, <ltl>, "-|>", bend: -20deg),

        edge(<ltl>, <pir>, "-|>", bend: -10deg),
        edge(<verif>, <pir>, "-|>", bend: 15deg),
        edge(<core>, <rtlil>, "-|>"),

        edge(<rtlil>, <ys-rtlil>, "<|--|>"),
        edge(<pir>, <ys-pir>, "<|--|>"),

        edge(<circt>, <yosys>, shift: -2em, "<|-|>"),
        edge(<circt>, <verilator>, "<|-|>"),
      )],
    [
      *Instruction Extension*
      - Extract verification statements from instruction behavior
        - Create checker circuits from verification statements with transformations in Yosys
      _New Design Flows_: Using CIRCT as an interchange framework enables
      novel methodologies. For example, _Chosys_ provides a _Chisel_-to-_Yosys_
      path without requiring SystemVerilog.
    ],
    result-box(title: "Status", dir: ltr)[
      - Prototype for CoreDSL to SVA conversion
      - CIRCT to Yosys via RTLIL demonstrated
      - Yosys Property IR defined
    ],
  ),
)

#let card_impact = card(
  "Open-Source Impact",
  heading-fill: palette.osvise-yellow.lighten(50%),
  body-fill: palette.osvise-yellow.lighten(95%),
  grid(
    gutter: 1em,
    rows: (auto, 1fr, auto),
    [
      - Development is done in the open
      - Enables outside collaboration
      - Allows for direct feedback
    ],
    align(center, box(
      fill: white,
      inset: 1em,
      stroke: style.stroke-muted,
      align(left, text(size: 20pt, [
        - Public access to new tools
          - #link-github("tum-ei-eda/isaac-perf-gen")
          - #link-github("Minres/CRIG")
          - #link-github("planvtech/PlanV_Verilator_Feature_Tests")
          - #link-github("hm-aemy/coredsl-to-sva")
          - #link-github("hm-aemy/Shortnail")
            - Extends: #link-github("esa-tu-darmstadt/Shortnail")
          - #link-github("hm-aemy/chosys")
          - #link-github("YosysHQ/property-ir")
          - #link-github(
              "tum-ei-eda/PerformanceSimulation_workspace",
            )
          - #link-github("iti-luebeck/sca-wal")
            - Extends: #link-github("ics-jku/wal")
        - Contributions to existing tools
          - #link-github("llvm/circt")
          - #link-github("tum-ei-eda/etiss")
          - #link-github("YosysHQ/yosys")
          - #link-github("verilator/verilator")
      ])),
    )),

    result-box(
      title: "",
      [Evolving the open-source EDA ecosystem through ongoing contributions,
        ensuring immediate impact and continuous improvement.],
    ),
  ),
)

// Simulation Framework
#let card_sim_framework = card(
  "Simulation Framework",
  heading-fill: palette.purple.lighten(85%),
  body-fill: palette.purple.lighten(95%),
  grid(
    rows: (1fr, auto),
    gutter: 1em,
    [
      - Extending Verilator UVM capabilities
      - UVM testbench for instruction extensions with tracing
    ],
    result-box(title: "Status", dir: ttb)[
      - Verilator: randomization and constraint handling
      - Equivalent verification results for example extension between
        commercial tools and Verilator
      - Successful RISC-V CPU firmware simulation using extended Verilator
    ],
  ),
)

// Footer
#let footer = block(
  width: 100%,
  fill: luma(98%),
  stroke: 2pt + palette.secondary,
  radius: 5pt,
  inset: 14pt,
  grid(
    columns: (auto, 2fr, 1fr),
    column-gutter: 2cm,
    align: center + horizon,

    // Partner logos
    grid(
      columns: (auto, auto, auto),
      stroke: (x, y) => if x > 0 { (left: 1pt + palette.dark-gray) },
      inset: 0.5cm,
      align: center + horizon,
      image("img/logo_hm_text.pdf", width: 8cm),
      image("img/logo_tuda.svg", width: 8cm),
      image("img/logo_uzl_text.pdf", width: 8cm),
      grid.hline(stroke: 1pt + palette.dark-gray),
      grid.cell(colspan: 3, align: center, grid(
        columns: (auto, auto),
        stroke: (x, y) => if x > 0 { (left: 1pt + palette.dark-gray) },
        inset: (x: 0.5cm),
        align: center + horizon,
        image("img/logo_tuw_text.pdf", width: 10cm),
        image("img/logo_tum_text.pdf", width: 10cm),
      )),
      grid.hline(stroke: 1pt + palette.dark-gray),
      image("img/logo_planv.pdf", height: 3cm),
      image("img/logo_minres.webp", width: 8cm),
      image("img/logo_yosys.png", width: 8cm),
    ),

    // Funding
    grid(
      columns: (auto, auto),
      column-gutter: 10pt,
      align: left + horizon,
      image("img/logo_BMFTR_DE.svg", height: 8cm),
      [#text(size: 24pt, [Funded by the German Federal Ministry
        of Research, Technology and Space.\
        Reference number: *16ME0953K*
      ])],
    ),

    // Website
    block(
      stroke: 5pt + palette.osvise-yellow,
      radius: 8pt,
      inset: 1cm,
      align(center + horizon)[
        #tiaoma.qrcode(
          height: 6cm,
          "https://di-osvise.github.io",
          options: (
            fg-color: palette.primary,
            dot-size: 1.1,
            output-options: (barcode-dotty-mode: true),
          ),
        )
        #text(fill: palette.primary)[#link(
          "di-osvise.github.io",
        )[di-osvise.github.io]]
      ],
    ),
  ),
)

#poster(
  header,
  card_overview, // 1
  card_sim_framework, // 2
  card_coreperf, // 3
  card_nonfunctional, // 4
  card_functional, // 5
  card_impact, // 6
  card_instr_stream, // 7
  footer,
)
