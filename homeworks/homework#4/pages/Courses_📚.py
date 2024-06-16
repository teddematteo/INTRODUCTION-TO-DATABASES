import streamlit as st
import utils as ut

cn = ut.check_connection("mysql+pymysql","root","mypassword","localhost","gym")

st.title("Information about :red[Courses]")

if cn:
    col1, col2 = st.columns(2)

    with col1:
        res = ut.execute_query("SELECT COUNT(*) AS num FROM COURSES")
        st.metric("#Courses",str(res.iloc[0,0]))

    with col2:
        res = ut.execute_query("SELECT COUNT(DISTINCT CType) AS num FROM COURSES")
        st.metric("#Types",str(res.iloc[0,0]))

    with st.form("form"):
        st.subheader("Find your course!")

        res = ut.execute_query("SELECT DISTINCT CType FROM COURSES")
        course_types = st.multiselect("Select the type you are interested:",res['CType'])

        course_level = st.slider("Select your level:",1,4)

        submitted = st.form_submit_button("Submit")

    if submitted:
        if len(course_types) < 1:
            st.warning("Please, select at least one type of course!")
        else:
            res = ut.execute_query(f"SELECT COUNT(*) FROM COURSES WHERE CType IN %(l1)s AND Level = %(l2)s", values = {"l1":course_types,"l2":course_level})

            if int(res.iloc[0,0]) == 0:
                st.error("No results")
            else:
                st.success("Your results:")

                res = ut.execute_query(f"SELECT * FROM COURSES WHERE CType IN %(l1)s AND Level = %(l2)s", values = {"l1":course_types,"l2":course_level})
                
                for index,row in res.iterrows():
                    with st.expander(row['Name'] + " - " + row['CodC'], expanded = False):
                        res = ut.execute_query(f"SELECT Day,StartTime,Duration,Room,I.Name AS InstructorName,I.Surname AS InstructorSurname FROM PROGRAM P,INSTRUCTOR I WHERE CodC = %(l1)s AND P.FisCode = I.FisCode", values = {"l1":row['CodC']})
                        st.write(res)
else:
    st.error("No internet connection")