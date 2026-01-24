module ERBLint
  module Linters
    class PlainHtmlLinter < Linter
      include LinterRegistry

      class ConfigSchema < LinterConfig
        property :custom_message, accepts: String
        property :forbidden_tags,
          accepts: array_of?(String),
          default: -> { ["form", "input", "select", "button", "label", "option", "textarea", "a", "img"] }
      end
      self.config_schema = ConfigSchema

      def run(processed_source)
        tags = processed_source.ast.descendants(:tag)

        return if tags.none?

        tags.each do |tag_node|
          next if tag_node.children.first&.type == :solidus # close tag

          tag_name_node = tag_node.descendants(:tag_name).first
          next unless tag_name_node

          tag_name = tag_name_node.children.first
          next unless @config.forbidden_tags.include?(tag_name)

          add_offense(tag_node.loc, "Plain HTML <#{tag_name}> tag detected")
        end
      end
    end
  end
end
