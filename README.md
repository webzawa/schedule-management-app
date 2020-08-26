# Schedule Management App

コンビニ経営者の知人に依頼されて作成した自作アプリです。<br />
従業員のシフト申請を一覧で見える化し、直感的な操作で承認する事ができます。<br />
機能としてはシンプルですが、開発環境にDocker、インフラにAWSを使用しています。

[![Screenshot from Gyazo](https://)](https://)

## URL
https://

* ログインページから【testuser】として簡単ログインできます。

## 使用技術
* Ruby 2.7.1, Rails 6.0.3.2
* Nginx, unicorn
* AWS (EC2, RDS for MySQL, S3, VPC, Route53, ALB, ACM)
* Docker
* RSpec
* SASS, Bootstrap, JQuery

## AWS構成図
![Untitled Diagram (2)](https://user-images.githubusercontent.com/)

## 機能一覧
* ユーザー登録・ログイン機能（devise）
* シフト作成・削除機能（Ajax）
* 投稿一覧・投稿詳細表示機能
* シフト承認機能（Ajax、adminユーザのみ許可）
* 店舗・管理者追加機能（adminユーザのみ許可）
* 検索機能（Ransack）
* Rspecによる自動テスト機能

## 課題、今後実装したい機能
* テストを充実させる
* 追加機能の実装
* 現在の使用用途では1社数店舗での利用しか出来ないが、複数社でも利用できるように改修したい。
