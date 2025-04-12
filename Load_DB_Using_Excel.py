
import pandas as pd
from sqlalchemy import create_engine

conn_string = 'postgresql://postgres:1234@localhost/Testpaint'    #Provide your own connection string
db = create_engine(conn_string)
conn = db.connect()

files = ['artist', 'canvas_size', 'image_link', 'museum_hours', 'museum', 'product_size', 'subject', 'work']

for file in files:
    df = pd.read_csv(fr'C:\Users\Savan\OneDrive\Desktop\Painting Project\Painting Data\{file}.csv')  #Replace with your own path
    df.to_sql(file, con=conn, if_exists='replace', index=False) 
