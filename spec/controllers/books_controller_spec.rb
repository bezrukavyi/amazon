describe BooksController, type: :controller do
  subject { create :book }
  let(:user) { create :user }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'get presenter' do
      params = { sorted_by: 'asc_title' }
      allow(controller).to receive(:params).and_return(params)
      expect(Books::IndexPresenter).to receive(:new).with(params: params)
      get :index
    end
  end

  describe 'GET #show' do
    it 'assigns book' do
      expect(Book).to receive_message_chain(:full_includes, :find_by)
      get :show, params: { id: subject.id }
    end

    context 'when book found' do
      before do
        get :show, params: { id: subject.id }
        allow(Book).to receive_message_chain(:full_includes, :find_by)
          .and_return(subject)
      end

      it 'assigns book' do
        expect(assigns(:book)).to eq(subject)
      end

      it 'assigns the requested book' do
        expect(assigns(:book)).to eq(subject)
      end
      it 'renders the :show template' do
        expect(response).to render_template(:show)
      end
    end

    context 'when book not found' do
      before do
        expect(Book).to receive_message_chain(:full_includes, :find_by).and_return(nil)
        get :show, params: { id: 1001 }
      end
      it 'redirect_to all books' do
        expect(response).to redirect_to(books_path)
      end
      it 'flash alert' do
        expect(flash[:alert]).to eq I18n.t('flash.failure.book_found')
      end
    end
  end

  describe 'PUT #update' do
    before do
      allow(Book).to receive(:find_by).with(subject.id).and_return(subject)
    end

    context 'success' do
      before do
        put :update, params: { id: subject.id, review: attributes_for(:review) }
      end
      it 'redirect to the book' do
        expect(response).to redirect_to(book_path(subject))
      end
      it 'flash notice' do
        expect(flash[:notice]).to eq I18n.t('flash.success.review_create')
      end
    end

    context 'failure' do
      before do
        put :update, params: { id: subject.id, review: attributes_for(:review, :invalid) }
      end
      it 'render show template' do
        expect(response).to render_template(:show)
      end
      it 'flash alert' do
        expect(flash[:alert]).to eq I18n.t('flash.failure.review_create')
      end
    end
  end
end
