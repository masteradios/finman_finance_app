from flask import Flask,request,jsonify
from livemint_rss import get_rss_feed
import yfinance as yf
from flask_socketio import SocketIO,send,emit,join_room,leave_room
from get_stockdata import get_stock_data
import random,time


app=Flask(__name__)
app.config['SECRET_KEY']='secret!'
socketio=SocketIO(app=app,cors_allowed_origin='*')

players={}
game_begin=False





@app.route("/getrss",methods=['POST'])
def get_data():
    data=request.json
    url=data['url']
    rssFeed=get_rss_feed(url)
    return jsonify({"data":rssFeed,"message":"success"})


@app.route("/getstocks",methods=['POST'])
def send_data():
    data = request.json
    period=str(data['period'])
    stock=data['stockName']
    details=get_stock_data(stock,period)
    return jsonify({"message":"success","data":details})



def give_result():
    global game_begin
    socketio.sleep(300)
    game_begin=False
    winner=max(players,key=lambda p:players[p]['points'])
    print(winner)
    winnerpoints=round(players[winner]['points'],2)
    socketio.emit('game_over',{"message":f"{winner} won with profit {winnerpoints}","winner":winner,"max_points":players[winner]['points'],"game_begin":game_begin})

def get_stocks_one_data(stockName):
    #stockName=data['stockName']
    # data=request.json
    # stockName=data['stockName']
    details=get_stock_data(stockName,'1mo')
    stockPrices=[stock['High']  for stock in details]
    print(random.choice(stockPrices)) 
    return round(random.choice(stockPrices),2)



@socketio.on('join')
def join_players(data):
    global game_begin
    username=data['username']
    print(f"username is {username}")
    if username not in players:
        players[username]={"points":0}
        join_room('gameRoom')
        emit('join',{'message':f"player {username} has connected","game_begin":game_begin},room='gameRoom')

    if(len(players)==2) and not game_begin:
        game_begin=True
        emit('join',{'message':"Game begins","game_begin":game_begin},room='gameRoom')
        socketio.start_background_task(give_result)
        socketio.start_background_task(sample)


@socketio.on('score')
def find_profit(data):
    username=data['username']
    points=data['points']
    isBought=data['isBought']
    stockName=data['stockName']
    #players[username]['points']+=points
    new_profit=0
    print(players)
    message=""
    if(isBought):
        message=f"Bought {stockName} at {points}"
    else:
        message=f"Sold {stockName} at {points}"
    emit('score',{"username":username,"points":points,"message":message},room='gameRoom')


@socketio.on('close')
def close(data):
    profit=data['profit']
    username=data['userName']
    players[username]['points']+=profit
    print(players)


@socketio.on('leave')
def on_leave(data):
    username = data['username']
    if username in players:
        leave_room('gameRoom')
        print('enter')
        emit('message', {"message": f"{username} has left the game.","game_begin":game_begin}, room='gameRoom')
        del players[username]
    print(players)



@socketio.on('get_stock')
def get_stocks_datas(data):
    while game_begin:
        currentPrice=get_stocks_one_data(data['stockName'])
        emit('get_stock',{"currentPrice":currentPrice},broadcast=all)
        socketio.sleep(2)
    
def sample():
    while game_begin:
        currentPrice=get_stocks_one_data('INFY')
        
        socketio.sleep(2)
        socketio.emit('get_stock',{"currentPrice":currentPrice})


if __name__=="__main__":
    socketio.run(app=app,port=3000,host='0.0.0.0')