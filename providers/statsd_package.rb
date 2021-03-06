include Statsd
def whyrun_supported? 
  true
end

use_inline_resources

action :create do
  if @current_resource.exists
    Chef::Log.info "#{ @new_resource } already exists - nothing to do."
  else
    converge_by("Create #{ @new_resource }") do
      create_statsd_package
      new_resource.updated_by_last_action(true)
    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::OpennmsStatsdPackage.new(@new_resource.name)
  @current_resource.name(@new_resource.name)

  if package_exists?(@current_resource.name, node)
     @current_resource.exists = true
  end
end


private

def create_statsd_package
  Chef::Log.debug "Adding statsd package: '#{ new_resource.name }'"
  file = ::File.new("#{node['opennms']['conf']['home']}/etc/statsd-configuration.xml")
  contents = file.read
  doc = REXML::Document.new(contents, { :respect_whitespace => :all })
  doc.context[:attribute_quote] = :quote 
  file.close
  
  package_el = REXML::Element.new("package")
  package_el.attributes['name'] = new_resource.name
  if !new_resource.filter.nil?
    filter_el = package_el.add_element("filter")
    filter_el.add_text(REXML::CData.new(new_resource.filter))
  end
  last_pkg_el = doc.root.elements["/statistics-daemon-configuration/package[last()]"]
  doc.root.insert_after(last_pkg_el, package_el)

  out = ""
  formatter = REXML::Formatters::Pretty.new(2)
  formatter.compact = true
  formatter.write(doc, out)
  ::File.open("#{node['opennms']['conf']['home']}/etc/statsd-configuration.xml", "w"){ |file| file.puts(out) }
end

