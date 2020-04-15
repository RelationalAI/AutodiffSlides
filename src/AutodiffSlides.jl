module AutodiffSlides

import Remark
using Weave

export build

function build(;open=false)
    md = weave("autodiff.jmd"; doctype="github", mod=Main)
    slides = Remark.slideshow(md, "slides",
        options = Dict("ratio" => "16:9"))
    open && Remark.open(slides)
end

end # module
