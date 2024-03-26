# frozen_string_literal: true

module LookupsHelper
  extend ActiveSupport::Concern
  included do
    scope :search_by_name, lambda { |keyword|
      preload(:string_translations)
        .then do |relation|
          if keyword.present?
            relation.joins(:string_translations)
              .where("mobility_string_translations.key = 'name'")
              .where("mobility_string_translations.value ILIKE :keyword", keyword: "%#{keyword}%")
          else
            relation
          end
        end
    }

    scope :order_by_name, lambda {
      joins("LEFT JOIN mobility_string_translations AS name_string_translations_by_locale ON (
        name_string_translations_by_locale.translatable_id = #{table_name}.id
        AND name_string_translations_by_locale.translatable_type = '#{name}'
        AND name_string_translations_by_locale.locale = '#{I18n.locale}'
        AND name_string_translations_by_locale.key = 'name'
      )".normalize_sql)
        .select("#{table_name}.*, name_string_translations_by_locale.value as order_by_name_value")
        .order(Arel.sql("order_by_name_value ASC, #{table_name}.id ASC"))
    }

    scope :order_by_priority, lambda {
      order("#{table_name}.priority DESC")
    }

    scope :order_by_id_desc, lambda {
      order("#{table_name}.id DESC")
    }
  end
end
