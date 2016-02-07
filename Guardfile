Bundler.require(:default)

guard 'shell' do
  watch(/.+\.adoc$/) {|m|
    `make html`
  }
end

guard 'livereload' do
  watch(%r{.+\.png})
  watch(%r{builds/.+\.html})
end
