import feedparser
import pandas as pd
#'https://www.livemint.com/rss/money'
def get_rss_feed(url):
    rss_feed = feedparser.parse(url)
    feed=[]
    for i,entry in enumerate(rss_feed.entries):
        if(i<10):
            date_part = entry.published[:16]
            feed.append({"title":entry.title,
                        "link":entry.link,
                        "published_time":date_part,
                        "summary":entry.summary})
            
    df=pd.DataFrame(feed,columns=["title",
    "link",
    "published_time",
    "summary"])
    return df.to_dict(orient='records')


