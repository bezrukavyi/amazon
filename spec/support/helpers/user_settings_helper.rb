module Support
  module UserSettings
    def fill_user_data(form_id, options)
      within "##{form_id}" do
        fill_in I18n.t('simple_form.labels.user.email'), with: options[:email]
        fill_in I18n.t('simple_form.labels.user.first_name'), with: options[:first_name]
        fill_in I18n.t('simple_form.labels.user.last_name'), with: options[:last_name]
        click_button I18n.t('simple_form.titles.save')
      end
    end

    def fill_password(form_id, options)
      within "##{form_id}" do
        fill_in I18n.t('simple_form.labels.user.current_password').first, with: options[:password]
        fill_in I18n.t('simple_form.labels.user.password'), with: options[:new_password]
        fill_in I18n.t('simple_form.labels.user.password_confirmation'), with: options[:new_password]
        click_button I18n.t('simple_form.titles.save')
      end
    end

    def destroy_account(form_id, confirm = nil)
      within "##{form_id}" do
        if confirm
          first('label', text: I18n.t('users.edit.remove_account.confirm_title')).click
        end
        click_button I18n.t('users.edit.remove_account.petition')
      end
    end
  end
end
