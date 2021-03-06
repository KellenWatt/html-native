module HTMLComponent
  # A list of all valid HTML5 elements. These are used to generate generator 
  # methods within HTMLComponent contexts.
  TAG_LIST = [
    :html, 
    :base, :head, :link, :meta, :style, :title,
    :body,
    :address, :article, :aside, :footer, :h1, :h2, :h3, :h4, :h5, :h6, :header, 
        :hgroup, :main, :nav, :section,
    :blockquote, :dd, :div, :dl, :dt, :figcaption, :figure, :hr, :li, :ol, :p, :pre, :ul,
    :a, :abbr, :b, :bdi, :bdo, :br, :cite, :code, :data, :dfn, :em, :i, :kbd, :mark, :q,
        :rb, :rp, :rt, :rtc, :ruby, :s, :samp, :small, :span, :strong, :sub, :sup, :time, 
        :u, :var, :wbr,
    :area, :audio, :img, :map, :track, :video,
    :embed, :iframe, :object, :param, :picture, :portal, :source,
    :svg, :math,
    :canvas, :noscript, :script,
    :del, :ins,
    :caption, :col, :colgroup, :table, :tbody, :td, :tfoot, :th, :thead, :tr,
    :button, :datalist, :fieldset, :form, :input, :legend, :meter, :optgroup,
        :option, :output, :progress, :select, :textarea,
    :details, :dialog, :menu, :summary,
    :slot, :template
  ]

  # A list of all limited attributes in HTML5. Any attribute not listed here are 
  # free to use in any element, as long as it is not in FORBIDDEN_ATTRIBUTES.
  #
  # Any attributes listed here will only be allowed in the associated elements.
  LIMITED_ATTRIBUTES = {
    accept: [:form, :input],
    "accept-charset": [:form],
    action: [:form],
    align: [:caption, :col, :colgroup, :hr, :iframe, :img, :table, 
            :tbody, :td, :tfoot, :th, :thead, :tr],
    allow: [:iframe],
    alt: [:area, :img, :input],
    async: [:script],
    autocomplete: [:form, :input, :select, :textarea],
    autofocus: [:button, :input, :select, :textarea],
    autoplay: [:audio, :video],
    buffered: [:audio, :video],
    capture: [:input],
    charset: [:meta, :script],
    checked: [:input],
    cite: [:blockquote, :del, :ins, :q],
    cols: [:textarea],
    colspan: [:td, :th],
    content: [:meta],
    controls: [:audio, :video],
    coords: [:area],
    crossorigin: [:audio, :img, :link, :script, :video],
    csp: [:iframe],
    data: [:object],
    datatime: [:del, :ins, :time],
    decoding: [:img],
    default: [:track],
    defer: [:script],
    dirname: [:input, :textarea],
    disabled: [:button, :fieldset, :input, :optgroup, 
               :option, :select, :textarea],
    download: [:a, :area],
    enctype: [:form],
    enterkeyhint: [:textarea],
    "for": [:label, :output],
    form: [:button, :fieldset, :input, :label, :meter, :object, 
           :output, :progress, :select, :textarea],
    formaction: [:input, :button],
    formentype: [:button, :input],
    formmethod: [:button, :input],
    formnovalidate: [:button, :input],
    formtarget: [:button, :input],
    headers: [:td, :th],
    height: [:canvas, :embed, :iframe, :img, :input, :object, :video],
    high: [:meter],
    href: [:a, :area, :base, :link],
    hreflang: [:a, :area, :link],
    "http-equiv": [:meta],
    importance: [:iframe, :img, :link, :script],
    integrity: [:link, :script],
    inputmode: [:textarea],
    ismap: [:img],
    kind: [:track],
    label: [:optgroup, :option, :track],
    language: [:script],
    loading: [:img, :iframe],
    list: [:input],
    loop: [:audio, :video],
    low: [:meter],
    max: [:input, :meter, :progress],
    maxlength: [:input, :textarea],
    minlength: [:input, :textarea],
    media: [:a, :area, :link, :source, :style],
    method: [:form],
    min: [:input, :select],
    multiple: [:input, :select],
    muted: [:audio, :video],
    name: [:button, :form, :fieldset, :iframe, :input, :object, 
           :output, :select, :textarea, :map, :meta, :param],
    novalidate: [:form],
    open: [:details],
    optimum: [:meter],
    pattern: [:input],
    ping: [:a, :area],
    placeholder: [:input, :textarea],
    poster: [:video],
    preload: [:audio, :video],
    readonly: [:input, :textarea],
    referrerpolicy: [:a, :area, :iframe, :img, :link, :script],
    rel: [:a, :area, :link],
    required: [:input, :select, :textarea],
    reversed: [:ol],
    rows: [:textarea],
    rowspan: [:td, :th],
    sandbox: [:iframe],
    scope: [:th],
    scoped: [:style],
    selected: [:option],
    shape: [:a, :area],
    size: [:input, :select],
    sizes: [:link, :img, :source],
    span: [:col, :colgroup],
    src: [:audio, :embed, :iframe, :img, :input, :script, :source, :track, :video],
    srcdoc: [:iframe],
    srclang: [:track],
    srcset: [:img, :source],
    start: [:ol],
    step: [:input],
    summary: [:table],
    target: [:a, :area, :base, :form],
    type: [:button, :input, :embed, :object, :script, :source, :style, :menu],
    usemap: [:img, :input, :object],
    value: [:button, :data, :input, :li, :meter, :option, :progress, :param],
    width: [:canvas, :embed, :iframe, :img, :input, :object, :video],
    wrap: [:textarea]
  }
  
  # These attributes are deprecated or outright forbidden. However, some people 
  # might still try to use them. These attributes are expressly disallowed 
  # during generation, and won't be included, even if provided.
  FORBIDDEN_ATTRIBUTES = [:background, :bgcolor, :border, :color, :manifest]
end
