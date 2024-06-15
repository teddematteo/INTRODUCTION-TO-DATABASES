import streamlit as st
import utils as ut
import datetime

ut.check_connection("mysql+pymysql","root","mypassword","localhost","gym")

st.title("Insertion of a new :red[Instructor]")

with st.form("form"):
    st.subheader("Find your instructor!")

    fiscode = st.text_input("Fiscal code*:")
    name = st.text_input("Name*:")
    surname = st.text_input("Surname*:")
    birthdate = st.date_input("Date of birth*:",value=datetime.date(1980,1,1))
    email = st.text_input("Email*:")
    telephone = st.text_input("Telephone:")

    st.write("*fields are mandatory")

    submitted = st.form_submit_button("Submit")

if submitted:
    if len(fiscode)>0 and len(name)>0 and len(surname)>0 and len(email)>0:
        res = ut.execute_query("SELECT COUNT(*) FROM INSTRUCTOR WHERE FisCode = %(l1)s", values = {"l1":fiscode})

        if res.iloc[0,0] == 0:
            #we can do the insertion
            #ut.execute_query_2(f"INSERT INTO INSTRUCTOR (FisCode,Name,Surname,BirthDate,Email,Telephone) VALUES('{fiscode}','{name}','{surname}','{birthdate}','{email}','{telephone}')")  #todo
            ut.execute_query_2(f"INSERT INTO `INSTRUCTOR`(`FisCode`, `Name`, `Surname`, `BirthDate`, `Email`, `Telephone`) VALUES('{fiscode}','{name}','{surname}','{str(birthdate)}','{email}','{telephone}')")
            st.success("Instructor inserted!")
        else:
            st.error("Instructor already present!")
    else:
        st.warning("Please, fill all the * fields")