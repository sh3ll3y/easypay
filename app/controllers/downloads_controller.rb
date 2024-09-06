class DownloadsController < ApplicationController
  before_action :authenticate_user!

  def index
    @downloads = current_user.downloads.order(created_at: :desc).page(params[:page]).per(10)
  end

  def create
    download = current_user.downloads.create!(status: :pending)
    TransactionDownloadJob.perform_later(download.id)
    redirect_to downloads_path, notice: 'Download job has been queued.'
  end

  def show
    download = current_user.downloads.find(params[:id])
    if download.completed?
      redirect_to download.full_url
    else
      redirect_to downloads_path, alert: 'Download is not ready yet.'
    end
  end
end
