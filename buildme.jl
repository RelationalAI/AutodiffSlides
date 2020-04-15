using Remark, Weave

function build()
    weave("autodiff.jmd"; doctype="github", mod=Main)
    slideshowdir = Remark.slideshow("autodiff.md", "slides",
                                options = Dict("ratio" => "16:9"))
end
# Open presentation in default browser.
# Remark.open(slideshowdir)
