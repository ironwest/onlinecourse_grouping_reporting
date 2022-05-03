

## Lec01:導入：テーブルワンとは===================

# スライド1-5　導入：テーブルワンとは？

## Lec02:集計をイメージで理解する=================

# スライド6-14

## Lec03:データ作成:========================

# ここからは、一つ前のレクチャーでダウンロードできるフォルダ内の
# 「Table1作成を通して学ぶグループ化.Rproj」の、
# lecture_script.Rを利用して解説を実施していきます。
# 
# プロジェクトの概念等がわからないかたは、まず
# 医師が教えるR言語での医療データ分析入門の基本的な部分だけでも
# 良いので見てから先に進んでください。



# それではRで集計を行っていきましょう。
# スライドでお示しした通り、集計とは、
# ベクトル（数字や文字列、因子などの要素）
# の特徴を何かしらの一つの代表的な値にまとめる
# ことになります
# 
# Rでこれを実施するためには、やりたい集計に
# 応じた関数を知っておく必要があります
# とりあえず、
# 
library(tidyverse)

dat <- tibble(
  num = c(1  ,2  ,3  ,4  ,5  ,6  ,7  ,8  ,9  ,10),
  fac2 =c("a","b","a","b","a","b","a","b","a","b") %>% as.factor(),
  fac3 =c("A","B","C","A","B","C","A","B","C","A") %>% as.factor()
)

dat
# こんな感じのtibbleを集計していくことを考えましょう
# 　numは数字ベクトル、
# 　fac2はレベルが二つの因子ベクトル、
# 　fac3はレベルが3つの因子ベクトル
# となります。

# ちなみに、繰り返しを簡単にできるrepという関数を
# 利利すると

rep( c("a","b"), 4)

# という感じで、最初に与えた要素、次に与えた数字の数
# だけくりかえしたベクトルを返してくれるので、
# 上のdatは、

dat <- tibble(
  num = 1:10,
  fac2 = rep(c("a","b"), 5),
  fac3 = rep(c("A","B","C"), 4)[1:10]
)

#とも書けます。
#fac3で[1:10]としているのは

tibble(num  = 1:3, 
       test = c("a","b","c","a","b","c"))

# このように、tibble内では、すべて同じ長さの
# 要素を与えないとエラーが生じるので、

tibble(num  = 1:3, 
       test = c("a","b","c","a","b","c")[1:3] )

#ようそをnumの数と同じだけにするためのものです。
#repを使うと与えた要素の長さの倍数の長さにしか
#ならないので、この[]は地味に大切です。


#100行で同様のパターンのものを作りたければ

dat <- tibble(
  num = 1:100,
  fac2 = rep(c("a","b"), 50),
  fac3 = rep(c("A","B","C"), 100)[1:100] 
)

#(本当はfac3繰り返し回数は34が最適ですが、
#計算するのが面倒なので全部100としています)
#
#ですし、X行のものを作る関数にしたければ、

genXrow <- function(X){
  tibble(
    num = 1:X,
    fac2 = rep(c("a","b")    , X)[1:X],
    fac3 = rep(c("A","B","C"), X)[1:X]
  )
}

dat <- genXrow(11)
dat

genXrow(10000)

# となります

# 余談でした。
# こういう風に、データを自分で作れるようになると
# 色々な関数や統計的なことを勉強する際に
# 自分で仕組みがわかっているデータを作成できるので
# おすすめです。
# 
# それでは、集計用の関数の解説を
# おこなっていきましょう


## Lec04:数値の集計(基本:個数、和、算術平均)====================

#ここは、簡単に関数を紹介いたします。

#==個数==

dat$num %>% length()

# これは簡単ですね。ベクトルの要素の個数を
# 算出します。

#==和==

dat$num %>% sum()

# はい。これも単純に全部足し合わせただけです

#==算術平均==

dat$num %>% mean()

#で計算できます。
#mean()をつかわないで計算するなら

sum(dat$num)/length(dat$num)

#と書いても計算可能です。

#　ここまでかいてきて、毎回dat$と書くのが面倒に
#　感じませんか？
#　
#　次の動画ではよりシンプルにこれらの演算をできる
#　書き方について解説していきます。

## Lec05:シンプルな書き方での演算(attach)====================

# 前の動画では、基本中の基本である、個数、和、平均の
# 関数について説明しました。
# 
# ただ、一般的にtibbleなどからベクトルを取り出す
# $記号を利用したスクリプトは、
#    書くのにタイプ量が増える、
#    tibbleの名前が長いと可読性が落ちる
# というところで、個人的にはお勧めできません。

# ですので、この動画では$サインをなるべく使わずに書く
# 方法についてご説明いたします。

# 方法1：`attach`を利用する方法

#一つ前の動画では、平均を求めるのに、
sum(dat$num)/length(dat$num)
#と記載していました。

#ただ、dat$と何回も打つのは面倒なので、
#できれば、次のようにnumとだけ打つことで
#ベクトルを呼び出せると便利です。

sum(num)/length(num) #エラーですね

#Environmentペーンの内容を少し覚えておいてください。

attach(dat) #とすると、ここ以降、dat$とかかなくてもOK

sum(num)/length(num)
num
fac2
fac3

detach(dat) #これでattach効果が消える
sum(dat$num)/length(dat$num)
sum(num)/length(num)　#エラー！

# 簡単ですね？
# ただ、detachを忘れたりするとエラーの原因になったり
# 思わぬ動作を引き起こすケースがあります。
# 具体的には。。

num <- 1000 #numという変数を使いたいので作成

#100行くらいのスクリプト

attach(dat) #fac2を利用したい

mean(num) #dat$numの平均を求めたつもり

#本当に求めたかったのは
mean(dat$num)

detach(dat)

#いかがでしょうか？
#このようなエラーが生じる可能性があるため、
#できればattach、detachは使わないようにしています

#ただし、ネットで検索した場合によく使われる関数
#でもあるのでここで紹介しました。
#
#次の動画では、atattch, detachを使わないで計算する
#方法を解説いたします。

## Lec06:シンプルな書き方での演算(dplyr::summarise)====================

# 方法2: DplyrのSummarise関数

# 実はDplyrには、attachと似たように利用できる
# `summarise`関数というものがあります。
# 本来の使い方とは少し違いますが、
# グループ集計を行う場合に必須の関数になるため、
# 単独での動きをしっかりと理解しておきましょう。

dat %>% 
  summarise(
    kosu  = length(num),
    mean1 = sum(num)/length(num),
    mean2 = mean(num)
  )

#だいぶattachと挙動が違いますがじっくりと
#みてみましょう

#datというデータを%>%でsummariseに与えてあげると、
#summariseの中では列名を書くだけで
#そのベクトルを利用することができます

#中では、<新しい列名>=<ベクトル演算>
#とすることで、その列名にベクトルの演算結果が
#でてきます。

#ここで注意が必要なのは<ベクトル演算>の
#演算結果の個数が1個のベクトルでないと
#エラーが起こるというところです。

dat %>% 
  summarise(
    a = c(1,2,3)
  )

#aは長さ1である必要があります（3ではありません）
#と怒られました。

dat %>% 
  summarise(
    a = 1
  )

#これなら大丈夫ですね。
#再度確認ですが、

length(dat$num)
sum(dat$num)/length(dat$num)
mean(dat$num)

#これらの演算結果はすべて長さが1です。なので

dat %>% 
  summarise(
    kosu  = length(num),
    mean1 = sum(num)/length(num),
    mean2 = mean(num)
  )

#このスクリプトの動作、腹落ちしましたか？

#さらに、この書き方の利点は、numという名前の変数が
#グローバル環境にあったとしても、問題なく
#意図した動作をしてくれるというところにあります。
#
#Environmentペーンを確認いただきたいのですが、
#ここまでのsummarise関数の実行時に、numという
#変数が存在している状態でした。
#しかし、それには影響を受けずに、与えられた
#データ/tibbleの列名がついたベクトルを
#取り出すことができています。
#この特徴があるため、attachを使うよりも思わぬエラーが
#回避できると思います。

#また、summarise関数の中でだけ動作する
#特別な関数もあるので次の動画ではその説明を行います。

## Lec07:summariseの中で動く特別な関数====================

#ここでは、n()について説明します。
#n()は、summarise、mutate、filter関数の中で
#動作する特別な関数です。
#
#その動作は、summarise,mutate,filterに与えられた
#データの列数を取得するというものになります。

#実際に、
n()
#単独で呼び出しても、data contextの中でしか呼び出せません
#と怒られました。


dat %>% 
  summarise(
    number1 = n(),
    number2 = length(num)
  )

nrow(dat)

#いかがでしょう？
#n()を利用することでこれまでlength(列名)と
#していたものをだいぶ簡略化できましたね？
#
#データ加工では割合の計算や、統計的な計算でも頻用する
#関数になるのでここで是非理解しておいてください。
#
#次の動画では、最初にご説明したデータの集計について
#説明していきます。

## Lec08:全体集計の実践(tidyverse)====================
#スライド14

id <- 1:15
age <- c(30,40,65,34,86,43,64,26,87,45,76,24,97,45,34)
gender <- c("m","m","f","f","f","m","m","f","f","m","f","f","m","m","m")
isx <- c(F,T,F,F,T,T,T,F,T,F,T,F,F,F,T)

dat <- tibble(id     = id, 
              age    = age, 
              gender = gender, 
              isx    = isx   )

#こんな感じのデータがあるとしましょう
dat

#スライドでお示しした通り、
#年齢と性別の個数を計算してみます

dat2 <- dat %>% 
  summarise(age_mean = mean(age),
            age_sd   = sd(age),
            gender_male_n  = sum(gender=="m"),
            gender_male_p  = 100*gender_male_n/n() )


# いかがでしょうか？
# 年齢の平均、標準偏差、性別の個数と割合の計算を
# ここでは行っていますが、スクリプトの動作、
# イメージできますか？
dat2
#このdat2をスライドでお示しした形に変換してみましょう
dat2

dat2 %>% 
  mutate_all(~{format(.,nsmall=1, digits=1)}) %>% 
  mutate(
    `年齢(平均±sd)` = str_c(age_mean,"±",age_sd),
    `性別:男性(%)`  = 
      str_c(gender_male_n,"(",gender_male_p,"%)")
  ) %>% 
  pivot_longer(everything()) %>% 
  slice(5:6) %>% 
  rename(`全体` = value, ` ` = name)

#どうでしょうか？集計できましたね？

#この変換について、すべての処理が理解できたという方は
#全体集計の実践(Arsenal)まで飛ばしていただいて
#構いません。
#
#次以降の動画では、この変換について
#1行ずつ解説していきます。

## Lec09:全体集計の実践(tidyverse)-解説====================


#まず、データを準備します
id <- 1:15
age <- c(30,40,65,34,86,43,64,26,87,45,76,24,97,45,34)
gender <- c("m","m","f","f","f","m","m","f","f","m","f","f","m","m","m")
isx <- c(F,T,F,F,T,T,T,F,T,F,T,F,F,F,T)

#tibble関数を利用してベクトルを一つの
#テーブルとしてまとめます
hyou <- tibble(id     = id, 
               age    = age, 
               gender = gender, 
               isx    = isx   ) %>% 

#サマライズを利用して、平均や個数のデータを集計します
  summarise(age_mean = mean(age),
            age_sd   = sd(age),
            gender_male_n  = sum(gender=="m"),
            gender_male_p  = 100*gender_male_n/n() ) 


#ここからが少し複雑ですが
hyou <- hyou %>% 
  mutate_all(~{format(.,nsmall=1, digits=1)})


#このmutate_allですべての変数のデータに対して
#format(列, nsmall=1, digits=1)
#を適応することで、数字型のデータを、
#小数点1桁で表記された文字列型に変換しています
#
#(mutate_allやmutate_atについての詳しい解説は
#「医師が教えるR言語でのデータ分析:
#　　R言語で作業自動化～エクセルデータの自動処理と
#　　パワーポイント作成～」
#　レクチャー21とレクチャー22で解説しています。
#　登録していないくてもプレビューで見れるよう
#　にしてありますので、そちらを参考にしてください。)

hyou <- hyou %>% 
  mutate(
    `年齢(平均±sd)` = str_c(age_mean,"±",age_sd),
    `性別:男性(%)`  = str_c(gender_male_n,"(",gender_male_p,")")
  )

hyou

#そして、最終的な目的となるデータをmutateで作成しています。

hyou <- hyou %>% 
  pivot_longer(everything())
hyou

#pivoit_longerはgather関数等と同様にデータを
#縦に長くする関数で、比較的新しい関数です
#gatherと動作は変わりませんが、
#因数の与えかたが少し変化していますので注意
#が必要です。
#(詳細は後のレクチャー:gatherとpivot_longerで
#解説を行います。)

hyou <- hyou %>% 
  slice(5:6)
#sliceで必要なデータだけのこせば

hyou <- hyou %>% 
  rename(` ` = name, `全体` = value)
#完成です。

hyou

#いかがでしょうか？
#今回は1ステップずつわけて関数の処理を実行しましたが
#実際は 

hyou <- tibble(id     = id,     age    = age, 
               gender = gender, isx    = isx   ) %>% 
  summarise(age_mean = mean(age),
            age_sd   = sd(age),
            gender_male_n  = sum(gender=="m"),
            gender_male_p  = 100*gender_male_n/n() ) %>% 
  mutate_all(~{format(.,nsmall=1, digits=1)})　%>% 
  mutate(
    `年齢(平均±sd)` = str_c(age_mean,"±",age_sd),
    `性別:男性(%)`  = str_c(gender_male_n,"(",gender_male_p,")")
  ) %>% 
  pivot_longer(everything()) %>% 
  slice(5:6) %>% 
  rename(` ` = name, `全体` = value)

hyou

#こんな感じで処理を書くと目的の集計ができあがりました！
#
#・・・「めんどくさい」と思ったそこのあなた。
#
#今回、tidyverseで説明をしたのは、グループ集計
#を行うための理解を深めていただくための
#手順をお見せするためです。
#
#次の動画では、パッケージを利用して
#お手軽に集計する方法をご説明いたします。

## Lec10:全体集計-Arsenalのイメージの解説-====================

# Rでデータを集計するためのパッケージは
# いろいろとあります
# 
# 検索していただければたくさん紹介されていると
# 思いますがここからは
# arsenalという
# 簡単に集計ができるパッケージをご紹介いたします。

# まずは、スライドでイメージの解説です　Slide16-

## Lec11:全体集計-ArsenalのRでの実践1=====================
#スライドでお示ししたことが実際に動くかを確認していきます。

#まずは,arsenalパッケージをインストールしておきましょう
#install.packages("arsenal")
#を実行してください。

age <- 
  c(30,40,65,34,86,
    43,64,26,87,45,
    76,24,97,45,34)

gender <- 
  c("m","m","f","f","f",
    "m","m","f","f","m",
    "f","f","m","m","m")

datarsenal <- 
  tibble(age = age, gender = gender)

datarsenal

#まず、tableby関数を利用して、

table_dat <- arsenal::tableby(
  formula = ~ age + gender, 
  data    = datarsenal
)

#formula = ~ age + genderという記載で、
#ageとgenderを集計することを指定します
#
#そのあとdata = datarsenalとしてどのデータを
#集計するか指定します。


summary(table_dat)

#ちょっと見づらいので、
summary(table_dat, text = TRUE)

#見やすくなりました。

#どうでしょうか？マークダウン形式
#(RmarkdownでKnitできる)でテーブルが出力されました。
#簡単ですね。

#日本語で表示したい場合を考えていきましょう。

#個数をカウントしたいものを因子型に置き換えておきます
datarsenal2 <- tibble(age = age, gender = gender) %>% 
  mutate(gender = factor(gender, 
                         levels = c("m","f"), 
                         labels = c("男性","女性")))

datarsenal2$gender

#ひとつ前と同じようにArsenalのtablebyを利用します
table_dat2 <- arsenal::tableby(
   ~ age + gender, 
  data = datarsenal2
)

summary(table_dat2,text=TRUE)

#因子の名前は日本語に置き換わりました。
#ただ、age、gender等は置き換えられていません。

#次の動画では、このラベルをコントロールする方法について
#解説していきます。


## Lec12:全体集計-Arsenalでの実践2 =======================
#それでは、一つ前に続いて、日本語化を行っていきましょう。
#まずは、置き換えたい英語と日本語を対応させたリストを作ります。
#作り方としてはこんな感じです。

labellist <- list(age     = "年齢(歳)", 
                  gender  = "性別")

#このような、
labellist
#を名前が付いたリスト(named list)といいます。

summary(table_dat2,text=TRUE)

#少しだけ厄介なのは、自動的に計算される（してくれる）
#Mean(SD)やRange等は別のリストを作成しないといけません。
#
#(利用できる名前の種類については)後ほど解説します
#
labelstatlist <- list(meansd = "平均(標準偏差)",
                      range = "範囲")

#それぞれのnamedlistを次のようなArgumentに与えて
#実行すると。。。

summary(object = table_dat2, 
        text   = TRUE,
        labelTranslations = labellist,
        stats.labels = labelstatlist)

#他にもいろいろな条件や要素をコントロールできます
#どのようなコントロールが可能かは、

?summary.tableby
?tableby.control


#に記載があります。例えば、

summary(object = table_dat2, 
        text   = TRUE,
        labelTranslations = labellist,
        stats.labels = labelstatlist,
        digits = 1
        )

# digits=1とすることで小数点のコントロールが可能です
# コントロールについて、
# 次の動画で使いまわす方法について解説を行います

## Lec13:全体集計の実践(arsenal)-コントロールを使いまわす====================
library(arsenal)
library(tidyverse)
# この動画では、tablebyのコントロールを使いまわす方法
# を考えてみましょう。

gendat <- function(n, mean, sd){
  tibble(
    kensa1 = rnorm(n,mean,sd),
    gender = sample(c("男性","女性"),
                    size    = n, 
                    replace = T)
  ) %>% 
    mutate(kensa1 = if_else(kensa1<0,0,kensa1))
}

#この関数は、与えた、n、mean、sdから、tibbleを生成します。

gendat(10,5,1)

#tibbleの内容は、列がkensa1とgenderの二つで、
#kensa1の値は、ランダムに平均mean、標準偏差sd
#の正規分布から値が出力されます
#（ただし負の数値の場合は0になります）

#(正規分布のことがわからないという方は、とりあえず、
#集計すると平均値がmeanの値になる数字が、
#sdの値に応じてばらついて数値が生成される
#という理解で十分です。)

#男性、女性は、
sample(c("a","b"),size = 10, replace = TRUE)

#sample関数を利用することで、最初に与えたargumentから、
#サンプリングを行うことで、ランダムに男性/女性を選択しています。




dat1 <- gendat(200,30,3)
dat2 <- gendat(100,50,5)
dat3 <- gendat(400, 50,20)

#さて、このデータ1-3をarsenalで
#集計することを考えます。
#
#ミニ課題です。集計できますか？
#
#一度動画を止めてご自身で
#スクリプトを書いてみてください。







# こんな感じでできましたか？

table_dat1 <- tableby(
  ~ kensa1 + gender, 
  data = dat1
)

summary(table_dat1, text=TRUE)

#あるいは、ラベルもきちんとつけるのであれば
label_column <- list(kensa1 = "検査1", 
                     gender = "性別")

label_stat   <- list(meansd = "平均(標準偏差)",
                     range  ="範囲")

summary(table_dat1, text = TRUE, 
        labelTranslations = label_column, 
        stats.labels = label_stat,
        digits = 1)

#ここで、これを残りのdatに適応することを考えると
#もう少し楽にしたくなりませんか？

#その場合は、tableby.controlという関数を利用すると
#tablebyの挙動だけを別のオブジェクトとして
#作成しておくことができます。
#具体的には、

table_control <- arsenal::tableby.control(
  stats.labels = label_stat, 
  digits = 1
)


tableby_dat1 <- tableby(formula = ~ kensa1 + gender,
        data = dat1, 
        control = table_control)

summary(tableby_dat1, text=TRUE)

summary(tableby_dat1, text=TRUE, 
        labelTranslations = label_column)

#こんな感じで、tablebyを実行する時点で
#ある程度の設定を反映させることができます。

summary(
  tableby(~kensa1+gender,dat1,control=table_control),
  text              = TRUE, 
  labelTranslations = label_column
)

summary(
  tableby(~kensa1+gender,dat2,control=table_control),
  text              = TRUE, 
  labelTranslations = label_column
)

summary(
  tableby(~kensa1+gender,dat3,control=table_control),
  text              = TRUE, 
  labelTranslations = label_column
)

#もちろん、関数化すれば、
#わざわざこんな方法をとらずともよいのですが

#この方法を用いると、

age <- c(30,40,65,34,86,
         43,64,26,87,45,
         76,24,97,45,34)
gender <- c("m","m","f","f","f",
            "m","m","f","f","m",
            "f","f","m","m","m")
datarsenal <- tibble(age = age, gender = gender)

datarsenal

tableby(~age+gender, datarsenal, 
        control = table_control) %>% 
  summary(text=TRUE)

#こんな感じで、formulaやデータが違うものに対しても同じ形式
#の集計テーブルが出力されるので便利です。

#ここまでで、データの集計について
#
# * dplyrを用いたスクリプト記載量が多いやり方、
# * arsenalを用いた簡便なやり方
#  
#の二通りについて解説してきました。
#
#次の動画からは、集団を集計する方法について解説を
#進めていきます。

## Lec14:集団集計(group_byのイメージでの理解)====================
#スライド

## Lec15:集団集計(group_byのアニメーションでの理解)====================
#スライド

## Lec16:集団集計(group_byの効果の確認)================================

#ひとつ前と二つ前の動画ではgroup_by関数についての イメージを作るための解説を実施してきました。
#
#ここからは、group_by関数のR上での動きについて 説明していきます。

#まず、改めて、スライドで解説したデータを生成します
id <- 1:15

age <- c(30,40,65,34,86,
         43,64,26,87,45,
         76,24,97,45,34)

gender <- c("f","m","f","f","f",
            "m","m","f","f","m",
            "f","f","m","m","m")

isx <- c(F,T,F,F,T,
         T,T,F,T,F,
         T,F,F,F,T)

dat <- tibble(id     = id    , age = age, 
              gender = gender, isx = isx)


#まずは、グループに分ける処理を行います。

dat %>% 
  group_by(isx)

#実行結果は特に普段と変わらなさそうですが、

#Groups:　isx[2]

#という表記がコンソール画面にでていることに
#気づきましたか？

#tible形式では、グループ化されたデータを印字すると
#このように、どのようなグループ分け
#(スライドでいう赤い線)
#が引かれているかを明記してくれます。

#では、group_by関数が本当に働いている
#のか、ちょっと実験してみましょう。
#次の二つのスクリプトの実行結果が
#どのように変わるか、予測できますか？

dat %>% 
  mutate(new = length(isx))

dat %>% 
  group_by(isx) %>% 
  mutate(new = length(isx))

#group_byを挟まない場合は、
#length(isx)は15個なので、
#
#newという新しい変数の中には
#15という数字が入っています。
#
#ところが、group_byを間にかませると、
#newは、isxの値がTRUEだと7、
#                FALSEだと8  という数字になっています

#このように、group_byを入れることで
#仮想の赤い線/データが仮に区切られている
#
#という状況が作り出されたことが確認できました。

#それでは、次の動画に進む前に、年齢、性別をisx毎に
#
# * 年齢は平均、標準偏差、
# * 性別は男性の数と全体に占める割合
#
#を計算するスクリプトを書いてみてください。


## Lec17:集団集計(group_byで集計してみよう)================================
#
#ひとつ前の動画での課題、やってみましたか？
#次のようなスクリプトができているば、こちらが
#意図していた通りとなります。

dat %>% 
  group_by(isx) %>% 
  summarise(
    age_mean = mean(age),
    age_sd   = sd(age),
    gender_m_n  = sum(gender=="m"),
    gender_m_p  = 100*gender_m_n/n()
  )

#割合計算のところが少しややこしいかもしれません。
#
#gender_m_nをn()で割ってあげることで
#グループ化された区分毎のgenderが"m"であるものの
#
#割合になっています。

#ところで、集団で「ない」集計のときに
#集計した結果を表示するスクリプトを
#再度記載してみます

res <- tibble(id     = id, 
              age    = age, 
              gender = gender, 
              isx    = isx   ) %>%
  
  summarise(age_mean = mean(age),
            age_sd   = sd(age),
            gender_male_n  = sum(gender=="m"),
            gender_male_p  = 100*gender_male_n/n() ) %>% 
  
  mutate_all(~{format(.,nsmall=1, digits=1)})　%>% 
  
  mutate(
    `年齢(平均±sd)` = str_c(age_mean,"±",age_sd),
    `性別:男性(%)`  = str_c(gender_male_n,"(",gender_male_p,")")
  ) %>%
  
  pivot_longer(everything()) %>%
  
  slice(5:6) %>%
  
  rename(` ` = name, `全体` = value)

res

#これの、summariseの手前にgroup_by(isx)をいれて、
#pivot_longer以降をコメントアウトして実行してみて
#ください。

tibble(id     = id, age    = age, 
       gender = gender, isx    = isx   ) %>% 
  group_by(isx) %>% #これを足して！
  summarise(age_mean = mean(age),
            age_sd   = sd(age),
            gender_male_n  = sum(gender=="m"),
            gender_male_p  = 100*gender_male_n/n() ) %>% 
  mutate_all(~{format(.,nsmall=1, digits=1)})　%>% 
  mutate(
    `年齢(平均±sd)` = str_c(age_mean,"±",age_sd),
    `性別:男性(%)`  = str_c(gender_male_n,"(",gender_male_p,")")
  )　 %>% View() 

#いかがでしょうか？isx毎に、
#最初に作った集計がうまくできていることが
#確認できますね？
#
#ここからコメントアウト
# %>%
# pivot_longer(everything()) %>%
#   slice(5:6) %>%
#   rename(` ` = name, `全体` = value)

#あとは、この結果をうまく最終的に表示したい

#|             | 疾病あり | 疾病なし|
#|年齢(平均±SD)|  ~~~~~~  | ~~~~~~~ |
#|性別:男性(%) |  ~~~~~~  | ~~~~~~~ |

#こんな形に持っていくことができたら
#最初の目標である、グループ集計の完成です。

#次の動画では、

#この形のデータを持っていきたいものに変換する
#方法について解説いたします。
#gather、あるいはpivot_longerを使いこなす
#必要があるので、この二つの関数の違いも
#続けて解説していきます。

## Lec18:変換の全体像================================

# この動画では
res <- tibble(id     = id, 
              age    = age, 
              gender = gender, 
              isx    = isx   ) %>% 
  group_by(isx) %>% #これを足して！
  summarise(age_mean = mean(age),
            age_sd   = sd(age),
            gender_male_n  = sum(gender=="m"),
            gender_male_p  = 100*gender_male_n/n() ) %>% 
  mutate_at(vars(-isx),~{format(.,nsmall=1, digits=1)})　%>% 
  mutate(
    `年齢(平均±sd)` = str_c(age_mean,"±",age_sd),
    `性別:男性(%)`  = str_c(gender_male_n,"(",gender_male_p,")")
  )

res

#を目的とする形に変換する方法について
#解説していきます。

#|             | 疾病あり | 疾病なし|
#|年齢(平均±SD)|  ~~~~~~  | ~~~~~~~ |
#|性別:男性(%) |  ~~~~~~  | ~~~~~~~ |


#(途中mutate_allの部分、
# isxに適応されると後の処理が少し面倒になるので、
# mutate_atでisxのみ除外して処理をしています)

#まず、「医師が教える～入門」(基本コース)で説明した
#gatherを用いる方法についてですが、これは、

res %>% 
  select(-starts_with("age"), 
         -starts_with("gender")) %>% #必要な列のみに
  gather(-isx, key = key, value = value) %>% #縦に並べる
  mutate(isx = factor(isx,
                      levels = c(TRUE, FALSE),
                      labels = c("疾病あり",
                                 "疾病なし"))) %>% 
  #次のspreadで広げた場合の列名としてTRUE・FALSEを
  #疾病あり・なしに変換 
  spread(key = isx, value = value) %>% #広げる
  slice(2,1) %>% #順番を入れ替える
  rename(` ` = key)

#いかがでしょうか？
#piot_longer, pivot_widerを利用するのであれば、

res %>% 
  select(-starts_with("age"), 
         -starts_with("gender")) %>% 
  pivot_longer(cols = c(-isx)) %>% 
  mutate(isx = factor(isx,
                      levels = c(TRUE, FALSE),
                      labels = c("疾病あり",
                                 "疾病なし"))) %>% 
  pivot_wider(id_cols     = name, 
              names_from  = isx, 
              values_from = value) %>% 
  select(1,3,2) %>% 
  rename(` ` = name)

#と細かな挙動は少しちがうのですが、基本的には
#　gather <=> pivot_longer
#　spread <=> piot_wider
#と互いに置き換え可能です。

#次の動画からは、
# gatherとpivot_longer
# spreadとpivot_wider
#の使い方を簡単にですが説明していきます。

## Lec19:gather <-> pivot_longer======

?tidyr::gather
# gatherの開発は完了したので、これからは
# pivot_longerを利用することを推奨する
# とヘルプに記載されています。
# この動画では簡単な例をあげつつ、gatherからpivot_longerへ
# の移行を説明します。

test <- tibble(
  id = 1:4,
  kensaA = 10:13,
  kensaB = 20:23
)

test
#こんなデータをgatherする場合は、

test %>% 
  gather(-id, key="keycol", value="valuecol")

#と、こんな感じで、横方向のデータを示すidを―で省いた
#うえで、keyとvalueの組み合わせとなる列名をそれぞれ
#指定してあげるというやり方でした。

#この考え方はpivot_longerでも全く同じで

test %>% 
  pivot_longer(cols = -id,
               names_to = "keycol",
               values_to = "valuecol")

#key:names_to values:values_toという対応です。
#gatherと比べると、argumentの名前が分かりやすいですね

## Lec20:spread <-> pivot_wider======

?tidyr::spread
# spreadの開発は完了したので、これからは
# pivot_widerを利用することを推奨する
# とヘルプに記載されています。
# この動画では簡単な例をあげつつ、
# spreadからpivot_widerへ
# の移行を説明します。

test <- tibble(
  id = rep(1:4,2),
  type = c(rep("kensaA",4),rep("kensaB",4)),
  atai = 101:108
)

test
#こんなデータをspreadする場合は、

test %>% 
  spread(key = type, value = atai)

#と、こんな感じで、列名にしたい列をkeyに、
#値にしたい列をvalueに指定してあげるだけでしたね？
#これを、pivot_widerで同様の処理をするには

test %>% 
  pivot_wider(names_from = type, 
              values_from = atai)

#key:names_from values:values_fromという対応です。
#gatherと同じく、argumentの名前から動作が
#どのようになるか、わかりやすいですね。

#pivot_系の関数には、gatherやspreadにはない新たな機能
#がたくさん追加されています。
#
#その詳細については、このコースの範囲を外れるので
#ここではこれ以上の解説は行いません。
#興味があるかたはYoutubeに作成者のHadley氏が解説している
#動画もあるので、見てみるとその背景がわかると思います。

#それでは、横道にそれてしまっていましたが、
#集団集計の話に戻り、次はAresenalパッケージでの
#集団集計について解説を続けます。


## Lec21:集団集計(Arsenalの復習)===========
#スライド

## Lec22:集団集計(Arsnalでの実践1)======

#では、arsenalを利用したグループ集計を
#実際のR上で行っていきましょう。

id <- 1:15
age <- c(30,40,65,34,86,
         43,64,26,87,45,
         76,24,97,45,34)
gender <- c("f","m","f","f","f",
            "m","m","f","f","m",
            "f","f","m","m","m")
isx <- c(F,T,F,F,T,
         T,T,F,T,F,
         T,F,F,F,T)

dat <- tibble(id     = id    , age = age, 
              gender = gender, isx = isx)

#グループ化しない場合の集計は、

hyou <- tableby(~age+gender, dat)
summary(hyou, text=TRUE)

#こんな感じです。
#グループ化するのは非常に簡単で、
hyoug <- tableby(isx~age+gender,dat)
summary(hyoug, text=TRUE)

#いかがでしょうか？
#~age+genderを列方向、isx~がグループ化する変数
#として指定してあげるだけでかなり簡便に
#集計表ができあがりました。

#続いて、出来上がる表の見た目を
#コントロールする方法を
#最低限説明していきます。

##検定結果の表示:
##
tabcontrol <- tableby.control(test = FALSE)

summary(tableby(isx~age+gender,dat                   ), text=TRUE                  )
summary(tableby(isx~age+gender,dat                   ), text=TRUE, pfootnote = TRUE)
summary(tableby(isx~age+gender,dat,control=tabcontrol), text=TRUE, pfootnote = TRUE)

#コントロールでtest=TRUEとすることで
#群間の差異について検定をしてくれます
#
#summaryにpfootnoteとつけると、
#何の検定をしたのか、記載してくれます
#
#より詳しい検定のコントロール方法については
#ヘルプファイルを参照してください
#(統計的な説明は本コースの範囲外となります)

##全体の結果の表示:
tabcontrol1 <- tableby.control(total = FALSE)
tabcontrol2 <- tableby.control(total = FALSE, test =FALSE)

summary(tableby(isx~age+gender,dat                   ), text=TRUE)
summary(tableby(isx~age+gender,dat,control=tabcontrol1), text=TRUE)
summary(tableby(isx~age+gender,dat,control=tabcontrol2), text=TRUE)

#totalのTRUE/FALSEで合計の値を
#コントロールすることができます。

#以上がarsenalの集団集計についての
#基本的な説明となります。
#
#次の動画では、
#
{hyoutidyverse <- tibble(id     = id, age    = age, 
              gender = gender, isx    = isx   ) %>% 
  group_by(isx) %>% #これを足して！
  summarise(age_mean = mean(age),
            age_sd   = sd(age),
            gender_male_n  = sum(gender=="m"),
            gender_male_p  = 100*gender_male_n/n() ) %>% 
  mutate_at(vars(-isx),~{format(.,nsmall=1, digits=1)})　%>% 
  mutate(
    `年齢(平均±sd)` = str_c(age_mean,"±",age_sd),
    `性別:男性(%)`  = str_c(gender_male_n,"(",gender_male_p,")")
  ) %>% 
  select(-starts_with("age"), 
       -starts_with("gender")) %>% 
  pivot_longer(cols = c(-isx)) %>% 
  mutate(isx = factor(isx,
                      levels = c(TRUE, FALSE),
                      labels = c("疾病あり",
                                 "疾病なし"))) %>% 
  pivot_wider(id_cols     = name, 
              names_from  = isx, 
              values_from = value) %>% 
  select(1,3,2) %>% 
  rename(` ` = name);hyoutidyverse
}

#tidyverse系の関数で作成したこのテーブルを
#arsenalで出力する手順を
#説明していきます。
#
#(完全には一致しませんがその点はご容赦を)

## Lec23:集団集計(Arsenalでの実践2)======
#
#ひとつ前の動画では、arsenalを利用して、

hyouarsenal <- summary(tableby(isx~age+gender,dat,test=F,total=F),text=T)

hyouarsenal

#こんな表を作る方法について解説しました。
#これを

knitr::kable(hyoutidyverse)

#こんな感じに変えていく手順を確認していきます。
#とはいっても、
#全体の集計で実施した方法と
#ほとんど手順は変わらないので、
#
#自分でできるという方は飛ばしてもらって構いません。

#データをまずは表記したいものに変えます。
hyoudat <- dat %>% 
  mutate(isx = factor(isx, 
                      levels = c(T,F),
                      labels = c("疾病あり",
                                 "疾病なし"))) %>% 
  mutate(gender = factor(gender,
                         levels = c("m","f"),
                         labels = c("男性","女性")))

#これだけで、
summary(
  tableby(isx~age+gender,
          hyoudat,
          test  = F,
          total = F),
  text=T
)
#こんな感じになりました。

#このままだと変数名で表記される部分と
#平均等の値が英語のままなので、

label_column <- list(age    = "年齢", 
                     gender = "性別" )

label_stat   <- list(meansd = "平均(標準偏差)",
                     range  ="範囲" )

hyoucontrol <- tableby.control(
  test         = FALSE, 
  total        = FALSE, 
  stats.labels = label_stat, 
  digits       = 1
)

summary(
  tableby(formula = isx~age+gender,
          data    = hyoudat,
          control = hyoucontrol),
  text= TRUE,
  labelTranslations = label_column
)

#さらに、範囲は今回いらないという場合には、
hyoucontrol <- tableby.control(
  test          = FALSE, 
  total         = FALSE, 
  stats.labels  = label_stat, 
  digits        = 1,
  numeric.stats = c("meansd")
)

summary(
  tableby(formula = isx~age+gender,
          data    = hyoudat,
          control = hyoucontrol),
  text= TRUE,
  labelTranslations = label_column
)

#また、2行もいらない！という場合は、
hyoucontrol <- tableby.control(
  test             = FALSE, 
  total            = FALSE, 
  stats.labels     = label_stat, 
  digits           = 1,
  numeric.stats    = "meansd", 
  numeric.simplify = TRUE, 
  cat.simplify     = TRUE
)

label_column <- list(age    = "年齢(平均±SD)", 
                     gender = "性別(男性:%)" )

summary(
  tableby(formula = isx~age+gender,
          data    = hyoudat,
          control = hyoucontrol),
  text= TRUE,
  labelTranslations = label_column
)

#いかがでしょうか？
hyoutidyverse
#とほぼ同じ表ができあがりました！

#最後に順番の入れ替え方法について
#補足説明をしておきます
#arsenalでは因子型のlevelの順番で表示されるので
#最初のhyoudatの部分の因子型に変換するところで
#順番を入れ替えれば任意の表記が可能です
#
hyoudat <- dat %>% 
  mutate(isx = factor(isx, 
                      levels = c(F,T), # <-T,F
                      labels = c("疾病なし",
                                 "疾病あり"))) %>% 
  mutate(gender = factor(gender,
                         levels = c("f","m"), #<- m,f
                         labels = c("女性",
                                    "男性")))

hyoucontrol <- tableby.control(
  test             = FALSE, 
  total            = FALSE, 
  stats.labels     = label_stat, 
  digits           = 1,
  numeric.stats    = "meansd", 
  numeric.simplify = FALSE, 
  cat.simplify     = FALSE
)

label_column <- list(age    = "年齢(平均±SD)", 
                     gender = "性別(女性:%)")

summary(
  tableby(formula = isx~age+gender,
          data    = hyoudat,
          control = hyoucontrol),
  text  = TRUE,
  labelTranslations = label_column
)

#こんな感じで表示したいレベルとあと、
#ラベルの設定を適切にいじりまることで、
#
#順番の入れ替えも簡単にできます。
#(年齢、性別の順番は
# formula = isx ~ age + gender 
# formula = isx ~ gender + age
#のformulaの指定で可能です)

#お疲れ様でした。
#以上で表の集計の基本的な事項についての
#解説は終了です！

#次の動画からは、
#本セクションの最初にお示ししたtable1を作成する
#課題の提示とその解説を行っていきます！

## Lec24:セクションの課題======
#スライド53、54
#でお示ししたテーブルを作ることが
#本セクションの課題です。
#
#まず、データを読み込みましょう

dat <- read_csv("practice_data1.csv")

#View(dat)
#こんなデータです。
#この、データ、kadai1_generator.Rにある関数で
#作成したものとなります
#
#データ生成のスクリプトに興味があれば、
#みてみてください。
#
#本コースでは特にこちらのスクリプトの解説は行いません。

#では、これを、スライドでお示しした
#形にもっていくことができますか？
#
#次の動画以降、回答となりますので、
#次の動画に進む前に、
#ご自身でどのようにスクリプトを記載するか
#考えてみてください。
#
#(自分なら、どのようにスクリプトを書くか等、
#ちょっとだけ考えていただいたら、次へ進んでください。)
#
#Tidyverseのみで作成する場合と
#Arsenalを利用する場合の二パターンで回答を用意しました。

## Lec25:課題解説:tidyverse==========================
#課題の解決方法は幾通りもあります。
#ここでご提示するものはあくまで例の一つとなります
#ので、最終的な形が一致していればそれで
#良いと思います。

#データの読み込み
dat <- read_csv("practice_data1.csv")

#グループ化して集計
dat$bpcat %>% unique() #カテゴリーの名前を確認

groupeddat <- dat %>% group_by(treatment)

datnum <- groupeddat %>% 
  summarise_at(vars(bmi, age, sbp, dbp),
               list(mean = mean, sd = sd)) %>% 
  mutate_at(vars(-treatment), 
            format, digits=1, nsmall=1)

#件数のカウントは、
datcount <- groupeddat %>%
  summarise(
    total_n    = n(),
    gender1n  = sum(gender == "Female"),
    gender1p  = 100*gender1n/n(),
    
    bpcat1n = sum(bpcat == "normal"),
    bpcat2n = sum(bpcat == "Elevated"),
    bpcat3n = sum(bpcat == "Htn Stage1"),
    bpcat4n = sum(bpcat == "Htn Stage2"),
    bpcat5n = sum(bpcat == "Htn Stage3"),
    
    bpcat1p = 100*bpcat1n/n(),
    bpcat2p = 100*bpcat2n/n(),
    bpcat3p = 100*bpcat3n/n(),
    bpcat4p = 100*bpcat4n/n(),
    bpcat5p = 100*bpcat5n/n()
  ) %>% 
  mutate_at(vars(ends_with("p")), 
            format, digits=1,nsmall=1)

dat1 <- left_join(datnum, datcount, by = "treatment")

hyou <- dat1 %>% 
  mutate(
    `年齢`         = str_glue("{age_mean}±{age_sd}"),
    `性別:女性`    = str_glue("{gender1n}({gender1p}%)"),
    `BMI`          = str_glue("{bmi_mean}±{bmi_sd}"),
    `血圧(収縮期)` = str_glue("{sbp_mean}±{sbp_sd}"),
    `血圧(拡張期)` = str_glue("{dbp_mean}±{dbp_sd}"),
    `血圧区分:正常`= str_glue("{bpcat1n}({bpcat1p}%)"),
    `血圧区分:高値`= str_glue("{bpcat2n}({bpcat2p}%)"),
    `血圧区分:1度`= str_glue("{bpcat3n}({bpcat3p}%)"),
    `血圧区分:2度`= str_glue("{bpcat4n}({bpcat4p}%)"),
    `血圧区分:3度`= str_glue("{bpcat5n}({bpcat5p}%)")
  ) %>% 
  mutate_all(as.character) %>% 
  select(-ends_with("_mean"), -ends_with("_sd"),
         -matches("\\d+[np]$"), -total_n) %>% 
  pivot_longer(cols = -treatment) %>% 
  pivot_wider(id_cols = name, names_from = treatment, values_from = value) %>% 
  rename(
    ` ` = name,
    `処置なし` = control,
    `処置あり` = treat
  )

#View(hyou)
#どうでしょうか？
#記載する行数が多いですが
#基本の関数を利用するだけでも
#このように集計した表が作成できました。

#実際分析を行う場合には、ここでお示ししたような
#手順をゼロから自分で書き上げることは、
#あまりしません。
#
#arsenalのようにその目的に合致したパッケージが
#あるケースが多々あるからです。
#
#それでは、次の動画ではarsenalを利用した
#集計の例を解説していきますが、
#ここまでの知識でできると思いますので、
#一度試みてみてください。

## Lec26:課題解説:arsenal==========================
# 
#では、実際にやってみましょう
hyoug <- 
  tableby(
    treatment~gender+age+bmi+sbp+dbp+bpcat, 
    data = dat
  )

summary(hyoug, text=TRUE)

#基本の形ですね。設定をいじっていきます

hyoucontrol <- 
  tableby.control(
    test          = FALSE,          #検定なし
    total         = FALSE,          #全体集計なし
    digits        = 1,　　          #小数点一桁に
    numeric.stats = "meansd",        #平均値(SD)のみでよい。
    stats.labels  = list(meansd = "平均(SD)"), #ラベルを設定
    numeric.simplify = TRUE,  #1行に出力を抑制
    cat.simplify     = TRUE　 #1行に出力を抑制
  )

hyoug <- 
  tableby(
    treatment~gender+age+bmi+sbp+dbp+bpcat, 
    data    = dat,
    control = hyoucontrol
  )

summary(hyoug, text=TRUE)

#日本語に置き換えましょう
unique(dat$gender)
unique(dat$treatment)
unique(dat$bpcat)

dat2 <- dat %>% 
  mutate(
    treatment = factor(treatment, 
                       levels=c("control","treat"),
                       labels=c("コントロール群",
                                "処置群")),
    gender    = factor(gender,
                       levels=c("Female","Male"),
                       labels=c("女性",
                                "男性")),
    bpcat     = factor(bpcat,
                       levels=c("normal",
                                "Elevated",
                                "Htn Stage1",
                                "Htn Stage2",
                                "Htn Stage3"),
                       labels=c("正常",
                                "高値",
                                "高血圧1度",
                                "高血圧2度",
                                "高血圧3度"))
  )

hyoug <- 
  tableby(
    treatment~gender+age+bmi+sbp+dbp+bpcat, 
    data    = dat2,
    control = hyoucontrol
  )

summary(hyoug, text=TRUE)

#もう一息、変数名を置き換えましょう
hensulabel <- list(gender = "性別:男性",
                   age    = "年齢",
                   bmi    = "BMI",
                   sbp    = "血圧(収縮期)",
                   dbp    = "血圧(拡張期)",
                   bpcat  = "血圧区分")

summary(hyoug,
        text              = TRUE, 
        labelTranslations = hensulabel)

#いかがでしょうか?
#tidyverseでゼロから作り上げるより
#既存のパッケージを利用したほうが楽に
#作成できましたね。
#
#ここまでで、データを集計して
#表を作成する方法の基本的なところ
#は解説できたと思います。
#
#おまけとして、ここで作成した表を
#レポートとして出力する方法について
#解説を行い、本セクションを終了します。
#

## Lec27:おまけ：arsenalの結果をパワーポイントで出力する方法==========================

# この動画では、新しくRmdファイルを作成して、
# 次のスクリプトをチャンクに埋め込み、
# パワーポイントファイルとして出力してみましょう
# 
#(Rmd、チャンク、パワーポイントへの出力については
#　別のコースで解説しておりますので、
# ここでは、やり方の確認のみとなることを
# ご了解ください）

# output.rmdに記載されいているスクリプトは
# 次に示したものです。
# output.rmdを確認してみましょう!
library(tidyverse)
library(arsenal)

dat <- read_csv("practice_data1.csv")

hyoucontrol <- 
  tableby.control(
    test          = FALSE,          #検定なし
    total         = FALSE,          #全体集計なし
    digits        = 1,　　          #小数点一桁に
    numeric.stats = "meansd",        #平均値(SD)のみでよい。
    stats.labels  = list(meansd = "平均(SD))"), #ラベルを設定
    numeric.simplify = TRUE,  #1行に出力を抑制
    cat.simplify     = TRUE　 #1行に出力を抑制
  )

dat <- dat %>% 
  mutate(
    treatment = factor(treatment, 
                       levels=c("control","treat"),
                       labels=c("コントロール群","処置群")),
    gender    = factor(gender,
                       levels=c("Female","Male"),
                       labels=c("女性","男性")),
    bpcat     = factor(bpcat,
                       levels=c("normal","Elevated","Htn Stage1","Htn Stage2","Htn Stage3"),
                       labels=c("正常","高値","高血圧1度","高血圧2度","高血圧3度"))
  )

hensulabel <- list(gender = "性別:男性",
                   age    = "年齢",
                   bmi    = "BMI",
                   sbp    = "血圧(収縮期)",
                   dbp    = "血圧(拡張期)",
                   bpcat  = "血圧区分")

hyoug <- tableby(treatment~gender+age+bmi+sbp+dbp+bpcat, 
                 data = dat2,control = hyoucontrol)

summary(hyoug, text=TRUE, labelTranslations = hensulabel)


# おつかれさまでした。ここまでで、本セクションは終了となります。
# 次のセクションでは、国立感染症研究所が公開しているデータを利用して
# 集計表とレポートの作成を行っていきます。

## Lec28: 補足説明: Tidyverseでの課題解説におけるsummarise_atの動作-------

groupeddat <- dat %>% group_by(treatment)

groupeddat

groupeddat %>% 
  summarise_at(vars(bmi, age, sbp, dbp),list(mean = mean, sd = sd))

groupeddat %>% 
  summarise(
    bmi_mean = mean(bmi),
    bmi_sd   = sd(bmi)  ,
    age_mean = mean(age),
    age_sd = sd(age),
    sbp_mean = mean(sbp),
    sbp_sd = sd(sbp),
    dbp_mean = mean(dbp),
    dbp_sd = sd(dbp)
  )
