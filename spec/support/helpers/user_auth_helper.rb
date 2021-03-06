module Support
  module UserAuth
    def sign_up(form_id, options)
      within "##{form_id}" do
        fill_in I18n.t('simple_form.labels.user.email'), with: options[:email]
        fill_passwords(options[:password])
        click_button I18n.t('simple_form.titles.sign_up')
      end
    end

    def sign_in(form_id, options)
      within "##{form_id}" do
        fill_in I18n.t('simple_form.labels.user.email'), with: options[:email]
        fill_in I18n.t('simple_form.labels.user.password'), with: options[:password]
        return yield if block_given?
        click_button I18n.t('simple_form.titles.log_in')
      end
    end

    def email_instruct(form_id, email)
      within "##{form_id}" do
        fill_in name: 'user[email]', with: email
        click_button I18n.t('devise.passwords.new.email_instruct')
      end
    end

    def fill_new_password(form_id, options)
      within "##{form_id}" do
        fill_in I18n.t('simple_form.labels.user.current_password').first, with: options[:password]
        fill_passwords(options[:new_password], 'new_password')
        click_button I18n.t('simple_form.titles.save')
      end
    end

    def reset_password(form_id, password)
      within "##{form_id}" do
        fill_passwords(password, 'new_password')
        click_button I18n.t('simple_form.titles.change')
      end
    end

    def fast_auth(form_id, email)
      within "##{form_id}" do
        fill_in I18n.t('simple_form.labels.user.email'), with: email
        click_button I18n.t('users.fast_auth.continue_button')
      end
    end

    def confirm_account_by_password(form_id, password)
      within "##{form_id}" do
        fill_passwords(password)
        click_button I18n.t('confirm_account')
      end
    end

    def get_confirm_email(email)
      open_email(email)
      current_email.click_link 'Confirm my account'
    end

    private

    def fill_passwords(password, type = 'password')
      fill_in I18n.t("simple_form.labels.user.#{type}"), with: password
      fill_in I18n.t('simple_form.labels.user.password_confirmation'), with: password
    end
  end
end
