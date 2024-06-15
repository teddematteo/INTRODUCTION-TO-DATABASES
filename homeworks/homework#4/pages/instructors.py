import streamlit as st
import utils as ut
import datetime

ut.check_connection("mysql+pymysql","root","mypassword","localhost","gym")

st.title("Available :red[Instructors]")

with st.form("form"):
    st.subheader("Find your instructor!")

    surname = st.text_input("Type the surname:")
    surname = "%"+surname+"%"

    date = st.date_input("Select the date range:",value=(datetime.date(1980,1,1),datetime.date(2024,6,15)))

    submitted = st.form_submit_button("Submit")

if submitted:
    res = ut.execute_query("SELECT COUNT(*) FROM INSTRUCTOR WHERE Surname LIKE %(l1)s AND BirthDate >= %(l2)s AND BirthDate <= %(l3)s", values = {"l1":surname,"l2":date[0],"l3":date[1]})

    if res.iloc[0,0] == 0:
        st.error("No instructor found!")
    else:
        st.success("Instructors found:")
        res = ut.execute_query("SELECT * FROM INSTRUCTOR WHERE Surname LIKE %(l1)s AND BirthDate >= %(l2)s AND BirthDate <= %(l3)s", values = {"l1":surname,"l2":date[0],"l3":date[1]})
        
        for index,row in res.iterrows():
            st.write(f"👨🏼 :red[{row['Name']} {row['Surname']}]")
            st.write(f"\tFiscal code: :blue[{row['FisCode']}]. Email: :blue[{row['Email']}]. Telephone: :blue[{row['Telephone']}]")
