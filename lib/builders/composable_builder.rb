class ComposableBuilder
  class << self
    def create(options = {})
      Class.new(ActionView::Helpers::FormBuilder) do
        include ComposableBuilders::Components::Global
        include ComposableBuilders::Components::Deformable if options[:deformable]
        include ComposableBuilders::Components::Printable if options[:printable]
        include ComposableBuilders::Components::Tagged if options[:tagged]
      end
    end
  end
end