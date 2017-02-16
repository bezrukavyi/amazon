module Support
  module Book
    def fill_review(form_id, options)
      within "##{form_id}" do
        fill_in I18n.t('simple_form.labels.review.title'), with: options[:title]
        fill_in I18n.t('simple_form.labels.review.desc'), with: options[:desc]
        choose("rate_#{options[:grade]}", visible: false)
        click_button I18n.t('simple_form.titles.save')
      end
    end
  end
end
