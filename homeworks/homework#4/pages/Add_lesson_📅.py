import streamlit as st
import utils as ut
import datetime

ut.check_connection("mysql+pymysql","root","mypassword","localhost","gym")

st.title("Insertion of a new :red[Lesson]")

with st.form("form",clear_on_submit=True):
    st.subheader("Add a new lesson!")

    res = ut.execute_query("SELECT FisCode FROM INSTRUCTOR")
    fiscode = st.selectbox("Instructor:",res['FisCode'])

    res = ut.execute_query("SELECT CodC FROM COURSES")
    course = st.selectbox("Course:",res['CodC'])

    room = st.text_input("Room:")

    day = st.selectbox("Day:",('Monday','Tuesday','Wednesday','Thursday','Friday'))

    hour = st.time_input("Time:")

    duration = st.slider("Duration:",5,60,30)

    submitted = st.form_submit_button("Submit")

if submitted:
    if len(fiscode)>0 and len(course)>0 and len(room)>0 and len(day)>0:
        res = ut.execute_query("SELECT COUNT(*) FROM PROGRAM WHERE CodC = %(l1)s AND Day = %(l2)s",values={"l1":course,"l2":day})

        if res.iloc[0,0] == 0:
            ut.execute_query_2(f"INSERT INTO `PROGRAM`(`FisCode`, `Day`, `StartTime`, `Duration`, `Room`, `CodC`) VALUES ('{fiscode}','{day}','{str(hour)}','{int(duration)}','{room}','{course}')")
            st.success("Lesson added")
        else:
            st.error("Lesson already planned")
    else:
        st.warning("Please, fill all the fields")