import streamlit as st
import pandas as pd
from sqlalchemy import create_engine, text

def connect_db(dialect, username, password, host, dbname):
    try:
        engine = create_engine(f'{dialect}://{username}:{password}@{host}/{dbname}')
        conn = engine.connect()
        return conn
    except:
        return False
    
def execute_query(query,values=None):
    return pd.read_sql(query,st.session_state["connection"],params=values)

def execute_query_2(query):
    st.session_state["connection"].execute(text(query))

def check_connection(dialect, username, password, host, dbname):
    res = connect_db(dialect,username,password,host,dbname)
    st.session_state["connection"] = res
    if not res:
        st.sidebar.error("No connection to the DB")
    else:
        st.sidebar.success("Correctly connected to the DB")
        
