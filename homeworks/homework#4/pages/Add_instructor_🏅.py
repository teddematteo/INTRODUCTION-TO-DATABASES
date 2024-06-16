import streamlit as st
import utils as ut
import datetime

cn = ut.check_connection("mysql+pymysql","teddepolito","mypassword","db4free.net:3306","gympoli")

st.title("Insertion of a new :red[Instructor]")

if cn:
    with st.form("form",clear_on_submit=True):
        st.subheader("Add a new instructor!")

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
                ut.execute_query_2(f"INSERT INTO `INSTRUCTOR`(`FisCode`, `Name`, `Surname`, `BirthDate`, `Email`, `Telephone`) VALUES('{fiscode}','{name}','{surname}','{str(birthdate)}','{email}','{telephone}')")
                st.success("Instructor inserted!")
            else:
                st.error("Instructor already present!")
        else:
            st.warning("Please, fill all the * fields")
else:
    st.error("No internet connection")