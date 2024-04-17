module ApplicationHelper
    def generate_breadcrumbs
        breadcrumbs = []
        breadcrumbs << { title: 'Home', path: root_path }
    
        case controller_name
        when 'categories'
          if action_name == 'show' && @category.present?
            breadcrumbs << { title: @category.name, path: category_path(@category) }
          end
        when 'products'
          if @product.present? && @product.category.present?
            breadcrumbs << { title: @product.category.name, path: category_path(@product.category) }
            breadcrumbs << { title: @product.name, path: product_path(@product) }
          end
        end
       
    
        breadcrumbs
      end
end
