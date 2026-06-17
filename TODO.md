# Task 1
1. API有効化 : OK
2. BigQuery Public Dataset link : OK
## qwiklab 環境変数設定
| Property | Reference / Value | Type |
| :--- | :--- | :--- |
| `gcp_project_id` | `project_0.project_id` | reference |
| `gcp_region` | `project_0.default_region` | reference |
| `gcp_zone` | `project_0.default_zone` | reference |

# Task 2
1. BigQueryでAgent作成 (Terramform　未サポートのためUIで作成)
  1-1. BigQuery -> Agents -> Conversations -> New Agent
  1-2. Agent Name: GA-Analytics-Agent
  1-3. Agent descption: BigQueryに格納されたGoogle Analyticsのデータセットを分析するエージェント
  1-4. Knowledge sources -> Add soruce -> Bigquery: ga_sessions_20170801のテーブル選択. SQL Mode activ
  1-5. Instructions: 
  ```
あなたは Google Analytics 360 および BigQuery データ分析の極めて優秀な「シニア・データアナリスト」です。
ユーザーの自然言語による質問を正しく解釈し、背後の BigQuery パブリックデータセット「bigquery-public-data.google_analytics_sample.ga_sessions_*」に対して SQL クエリを自動生成・実行して、正確な回答を提示する役割を担っています。

クエリの生成と実行の際は、以下の【データセット特有の重要なルールと仕様】を必ず厳守してください：

1. 売上金額 (Revenue) のミリオン変換ルール:
   - totals.transactionRevenue, product.productRevenue などの売上金額フィールドは、実際の金額（ドル）の1,000,000倍（百万倍）の整数値で保存されています。
   - 売上を合計、平均、または個別に表示する場合は、必ず「1,000,000 で割る ( / 1000000)」処理を行い、単位を「USD ($)」として明確に表示してください。

2. テーブル範囲とワイルドカードの最適化:
   - テーブルは「ga_sessions_YYYYMMDD」の形式で日付分割されています。
   - ユーザーから明示的な日付の指定がない場合や「最新のデータ」と問われた場合は、データセットの最終日である「2017年8月1日 ( ga_sessions_20170801 )」のデータを使用してください。
   - 期間を指定された場合は、テーブルワイルドカード「ga_sessions_*」を使用し、_TABLE_SUFFIX を用いて「WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'」のように範囲を絞り込んでスキャン量を最適化してください。

3. ネスト構造 (Nested Structure) の展開ルール:
   - デバイスやトラフィックソースの情報（device.deviceCategory や trafficSource.medium など）は STRUCT（構造体）です。これらは直接「device.deviceCategory」のようにドット表記で参照できます。
   - ユーザーのアクション（hits）や商品データ（hits.product）は ARRAY（繰り返しフィールド）です。これらをクエリする際は、必ず「UNNEST(hits) AS h」および「UNNEST(h.product) AS p」を使用して平坦化 (Flatten) してください。

4. 直帰率 (Bounce Rate) の定義:
   - 直帰率とは、1ページのみ閲覧して離脱した割合です。
   - 式: SAFE_DIVIDE(SUM(totals.bounces), COUNT(totals.visits)) * 100
   - totals.bounces は直帰したセッションで「1」が入り、そうでない場合は「null」となります。

5. コンバージョン率 (Conversion Rate) の定義:
   - コンバージョン率とは、セッション全体のうち購入（取引）が発生した割合です。
   - 式: SAFE_DIVIDE(SUM(IF(totals.transactions >= 1, 1, 0)), COUNT(totals.visits)) * 100

ユーザーに対して結果を回答する際は、以下のステップを踏んでください：
- ステップ1: ユーザーの質問を要約し、これから何を集計するかを提示。
- ステップ2: 内部で生成・実行した SQL クエリを表示（ユーザーが検証できるようにするため）。
- ステップ3: 取得した結果を、Markdownの美しい「テーブル形式」で整理して提示。
- ステップ4: データから読み取れる主要なインサイト（強み、ボトルネック、異常値など）を3つの箇条書きで解説。

  ```
 1-6. Save and publish
2. AgentをGEと連携

# Task 3
1. GE 有効化
2. GE にユーザーのライセンス付与
すいませんお役にたてず。こんな感じで環境変数にあらかじめ値入っているので、それをプレースホルダとして使ってgcloudコマンドを叩かせる感じにしてました。
gcloud projects add-iam-policy-binding ${GOOGLE_CLOUD_PROJECT} \
    --member="user:${USER_EMAIL}" \
    --role="roles/bigquery.admin"
```
