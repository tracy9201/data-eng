# coding=utf-8
# This is a sample Python script.

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.


import pandas as pd
import psycopg2
from psycopg2 import OperationalError


def execute_source_sql_script_file():
    file = open("/Users/nikhil.gutha/Desktop/Source.txt", 'r')
    sql_script_string = file.read()
    # print(sql_script_string)
    file.close()
    return sql_script_string


def execute_destination_sql_script_file():
    file = open("/Users/nikhil.gutha/Desktop/Destination.txt", 'r')
    # Read out the sql script text in the file.
    sql_script_string = file.read()
    file.close()
    return sql_script_string


def print_hi(name):
    # Use a breakpoint in the code line below to debug your script.
    print("Print, {0}".format(name))  # Press ⌘F8 to toggle the breakpoint.


def compare_results(resultsource, resultdestination):
    flag = resultsource.equals(resultdestination)
    # flag = bool(resultsource == resultdestination)
    # flag = False
    if flag:
        return flag
    else:
        result = resultsource.compare(resultdestination, keep_shape=True)
        return result
        # print(result)


def create_connection(db_name, db_user, db_password, db_host, db_port):
    connection = None
    try:
        connection = psycopg2.connect(
            database=db_name,
            user=db_user,
            password=db_password,
            host=db_host,
            port=db_port,
        )
        print("Connection to PostgreSQL DB successful")
    except OperationalError as e:
        print(f"The error '{e}' occurred")
    return connection


def execute_read_query(connection, query):
    cursor = connection.cursor()
    result2 = None
    try:
        cursor.execute(query)
        result2 = cursor.fetchall()
        text = ""
        for row in result2:
            text = str(row)
           # print(text)
        columns = [desc[0] for desc in cursor.description]
        # print(columns)
        cursor.close()
        df = pd.DataFrame(data=result2, index=None, columns=columns)
        return df
    except OperationalError as e:
        print(f"The error '{e}' occurred")


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    connection_source = create_connection('utah-odf', 'utah-odf', 'sHS4jtzIGiGNTdT',
                                          'hintdb-atlas.cluster-ro-cxfeateo6sft.us-east-1.rds.amazonaws.com', '5432')

    connection_destination = create_connection('reportingdb', 'qadbadmin', 'Hintmd43v3r!',
                                               'qa-reporting-cluster.cmmotnszowfl.us-east-1.redshift.amazonaws.com',
                                               '5439')
    resultsource = execute_read_query(connection_source, execute_source_sql_script_file())

    print(resultsource)

    resultdestination = execute_read_query(connection_destination, execute_destination_sql_script_file())

    print(resultdestination)

    result = compare_results(resultsource, resultdestination)
    print("Comparing OLTP vs OLAP")
    print(result)

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
