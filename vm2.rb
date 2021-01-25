require 'io/console'
class VendingMachine
  MONEY = [10, 50, 100, 500, 1000].freeze
  def initialize
    @slot_money = 0
    @drinks = Drink.new.drink_stock
    @sale_proceeds = 0
    main
  end
  def main
    loop do
      puts "何をしますか？"
      puts "0.入金,1.購入,2.おつり返却"
      accept_input = gets.to_i
      if [0,1,2,99].include?(accept_input)
        case accept_input
          when 0
            slot_money
            current_slot_money
          when 1
            drinks_store
            buy_drink
          when 2
            return_money
            break
          when 99
            sales_management
        end
      else
        puts 'メニューに無い処理です'
      end
    end
  end

  private
  def sales_management
    3.times{ |n|
      puts "パスワードを入力してください。"
      pass = STDIN.noecho(&:gets).chomp!
      if pass == "admin"
        loop do
          puts "何をしますか？"
          puts "0.売り上げ回収, 1.在庫補充, 2.在庫確認, 3.ドリンク追加, 4.ドリンク削除, 5.終了"
          @accept_input = gets.to_i
          if [0,1,2,3,4,5].include?(@accept_input)
            case @accept_input
              when 0
                puts "売上金、#{@sale_proceeds}円払いだします。"
                @sale_proceeds = 0
              when 1
                @drinks.each do |d|
                  d[:stock] = 5
                end
                puts '在庫を補充しました。'
                @drinks.each do |d|
                  puts "#{d[:name]}の在庫:" "#{d[:stock]}本"
                end
              when 2
                @drinks.each do |d|
                  puts "#{d[:name]}の在庫:" "#{d[:stock]}本"
                end
              when 5
                break
              when 4
                # メソッドにしておく
                puts "なにを削除しますか？"
                @drinks.each_with_index do |t, n|
                  puts "#{n}: #{t[:name]}"
                end
                @accept_input = gets.to_i
                if @drinks[@accept_input]
                  @drinks.delete_at(@accept_input)
                else
                  puts '対応するドリンクがありませんでした'
                end
              when 3
                add_drink_variety
            end
        else
          puts '対応するメニューがありませんでした'
        end
        end
        break
      elsif n == 2
        puts "通報しました。"
        break
      else
        puts "パスワードが間違っています。"
      end
    }
  end
  def drinks_store
    puts "なにを購入しますか？"
    @drinks.each_with_index do |t, n|
      puts "#{n}: #{t[:name]}"
    end
  end
  def buy_drink
    puts "購入する飲み物の番号を入力してください"
    n = gets.to_i
    if @drinks[n]
      if @slot_money <= @drinks[n][:price]
        current_money = @drinks[n][:price] - @slot_money
        puts "#{current_money}円足りません。"
      elsif @drinks[n][:stock] <= 0
        puts "在庫がありません。"
      else
        @slot_money = @slot_money - @drinks[n][:price]
        @drinks[n][:stock] -= 1
        @sale_proceeds += @drinks[n][:price]
        puts "残金は#{@slot_money}円です。"
      end
    else
      puts '対応するドリンクがありません'
    end
  end
  def current_slot_money
    puts "#{@slot_money}円入金済みです。"
  end
  def slot_money#(money)
    puts "お金を入れてください"
    puts "取り扱い可能な金額は10円、50円、100円、500円、1000円です"
    money = gets.to_i
    if MONEY.include?(money)
      @slot_money += money
    else
      puts "#{money}円は無効です。返却します。"
    end
  end
  def return_money
    puts "#{@slot_money}円を返却します。"
    @slot_money = 0
  end
  def add_drink_variety
    puts 'ドリンク追加します'
    puts 'ドリンクの名前は？ '
    d_name = gets.chomp
    puts 'ドリンクの値段は？: '
    d_price = gets.to_i
    @drinks << {name: d_name, price: d_price, stock: 5}
  end
end

class Drink
  attr_accessor :drink_stock
  def initialize
    @drink_stock = [
                {name: 'coke', price: 120, stock: 5},
                {name: 'redbull', price: 200, stock: 5},
                {name: 'water', price: 100, stock: 5}
               ]
  end
end
vm = VendingMachine.new
