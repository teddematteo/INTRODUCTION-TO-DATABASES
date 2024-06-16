import streamlit as st
import pandas as pd
import utils as ut
from sqlalchemy import text

st.set_page_config (
    page_title = "Homework#4",
    layout = "wide",
    initial_sidebar_state = "expanded",
    menu_items = {'Get help':"https://www.polito.it"}
)

#st.sidebar.image("/mount/src/introduction-to-databases/homeworks/homework#4/media/logo.png", use_column_width=True)

cn = ut.check_connection("mysql+pymysql","teddepolito","mypassword","db4free.net:3306","gympoli")

st.title(":red[Homework #4] - Matteo Tedde - s307688")
st.header("Overview of the activities")

if cn:
    col1, col2 = st.columns(2)

    with col1:
        st.subheader(":blue[Lessons for each time slot]")
        res = ut.execute_query("SELECT Day,StartTime,COUNT(*) AS tot FROM PROGRAM GROUP BY Day,StartTime ORDER BY Day ASC")
        
        res['timeslot'] = res['Day'].astype(str) + " " + res['StartTime'].astype(str)
        st.bar_chart(res.set_index('timeslot')['tot'])

    with col2:
        st.subheader(":blue[Lessons for each day of the week]")
        res = ut.execute_query("SELECT Day,COUNT(*) AS tot FROM PROGRAM GROUP BY Day")
        st.area_chart(res.set_index('Day')['tot'])
else:
    st.error("No internet connection")