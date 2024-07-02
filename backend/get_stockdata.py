import yfinance as yf
def get_stock_data(stockName,period):
    name=yf.Ticker(stockName)
    name_price=name.history(period=period)
    
    #name_price.set_index('Date', inplace=True)
    # Reset index to include date in the data
    name_price.reset_index(inplace=True)
    name_price['name']=stockName
    #print(name_price)
    return name_price.to_dict(orient='records')