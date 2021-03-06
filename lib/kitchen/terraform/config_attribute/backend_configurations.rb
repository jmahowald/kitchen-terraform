# frozen_string_literal: true

# Copyright 2016 New Context Services, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "kitchen/terraform/config_attribute"
require "kitchen/terraform/config_attribute_cacher"
require "kitchen/terraform/config_attribute_definer"
require "kitchen/terraform/config_schemas/hash_of_symbols_and_strings"

# This attribute comprises {https://www.terraform.io/docs/backends/config.html Terraform backend configuration}
# arguments to complete a
# {https://www.terraform.io/docs/backends/config.html#partial-configuration partial backend configuration}.
#
# Type:: {http://www.yaml.org/spec/1.2/spec.html#id2760142 Mapping of scalars to scalars}
# Required:: False
# Example::
#   _
#     backend_configurations:
#       address: demo.consul.io
#       path: example_app/terraform_state
#
# @abstract It must be included by a plugin class in order to be used.
module ::Kitchen::Terraform::ConfigAttribute::BackendConfigurations
  # A callback to define the configuration attribute which is invoked when this module is included in a plugin class.
  #
  # @param plugin_class [::Kitchen::Configurable] a plugin class.
  # @return [void]
  def self.included(plugin_class)
    ::Kitchen::Terraform::ConfigAttributeDefiner
      .new(
        attribute: self,
        schema: ::Kitchen::Terraform::ConfigSchemas::HashOfSymbolsAndStrings
      )
      .define plugin_class: plugin_class
  end

  # @return [::Symbol] the symbol corresponding to the attribute.
  def self.to_sym
    :backend_configurations
  end

  extend ::Kitchen::Terraform::ConfigAttributeCacher

  # @return [::Hash] an empty hash.
  def config_backend_configurations_default_value
    {}
  end

  # @return [::String] the elements of the value converted to flags, joined by white space.
  def config_backend_configurations_flags
    config_backend_configurations
      .map do |key, value|
        "-backend-config='#{key}=#{value}'"
      end
      .join " "
  end
end
