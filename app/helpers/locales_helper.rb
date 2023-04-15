# frozen_string_literal: true

# Locales helper
module LocalesHelper
  def v_t(var)
    t("views.#{params[:controller]}.#{params[:action]}.#{var}")
  end

  def v_t_breadcrumb
    t("view.#{params[:controller]}.breadcrumb")
  end

  def v_t_global(var)
    t("view.#{var}")
  end

  def ar_t(var)
    t("activerecord.attributes.#{var}")
  end

  def ar_t_explanation(model_name, field_name)
    t("activerecord.attributes.#{model_name}.#{explanations}.#{field_name}")
  end

  def display_field_explanation?(model_name, field_name)
    !ar_t_explanation(model_name, field_name).include?('translation_missing')
  end

  def c_t(var)
    t("controller.#{params[:controller]}.#{var}")
  end
end

