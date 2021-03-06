require 'rexml/document'

actions :create
default_action :create

attribute :ds_name, :kind_of => String, :name_attribute => true
attribute :group, :kind_of => String, :default => 'mib2', :required => true
attribute :type, :kind_of => String, :equal_to => ['high', 'low', 'relativeChange', 'absoluteChange'], :default => 'high', :required => true
attribute :description, :kind_of => String
attribute :ds_type, :kind_of => String, :default => 'node', :required => true
attribute :value, :kind_of => Float, :required => true
attribute :rearm, :kind_of => Float, :required => true
attribute :trigger, :kind_of => Fixnum, :default => 1, :required => true
attribute :ds_label, :kind_of => String
attribute :triggered_uei, :kind_of => String
attribute :rearmed_uei, :kind_of => String
# only relevent if resource filters present
attribute :filter_operator, :kind_of => String, :equal_to => ['and', 'or'], :default => 'or'
# Array of hashes with two keys each: 'field', 'filter'. Like:
# [{'field' => 'ifHighSpeed', 'filter' => '^[1-9]+[0-9]*$'}, ... ]
attribute :resource_filters, :kind_of => Array

attr_accessor :exists, :group_exists, :ds_type_exists, :ueis_exist
