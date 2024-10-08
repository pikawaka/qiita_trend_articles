class PathsController < ApplicationController
  def edit
    @path = Path.last
  end

  def update
    # pathは常に1件
    @path = Path.find(1)
    if @path.update(path_params)
      redirect_to root_path, notice: '設定が完了しました。明日の8時から適用されます。'
    else
      render :edit
    end
  end

  private

  def path_params
    params.require(:path).permit(:path)
  end
  def self.slack_bot(articles)
    notifier = Slack::Notifier.new ENV['WEBHOOK_URL'] do
      defaults channel: "#目指せ宮嶋", username: "通知BOT"
    end

    tag = Path.first.path.split('/').last
    articles.unshift("<設定タグ: #{tag}>")
    articles.unshift("【おはようございます。本日の新着記事です!】")
    message = articles.join("\n")
    notifier.ping message  # Slackに通知するメッセージ
  end
end
