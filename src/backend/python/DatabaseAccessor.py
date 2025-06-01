from datetime import datetime
import threading
import psycopg2

from DataSet import DataSet


connStr = "dbname=smartgreenhouse user=pi password=pi"
lock = threading.Lock()


class DatabaseAccessor:
    def create_tables(self):
        lock.acquire()
        """ create table for sensors in the PostgreSQL database"""
        command1 = (
            """
            CREATE TABLE "sensors"(
                "Counter" SERIAL,
                "Timestamp" VARCHAR(60),
                "Temperature" NUMERIC(3, 1),
                "Humidity"	NUMERIC(3, 1),
                "SoilMoisture"	NUMERIC(3, 1),
                PRIMARY KEY( "Counter" )
            );
            """)

        """ create table for actors in the PostgreSQL database"""
        command2 = (
            """
            CREATE TABLE "actors"(
                "Counter" SERIAL,
                "Timestamp" VARCHAR(60),
                PRIMARY KEY( "Counter" )
            );
            """)

        conn = None

        try:
            conn = psycopg2.connect(connStr)
            cur = conn.cursor()
            cur.execute(command1)
            cur.execute(command2)
            cur.close()
            conn.commit()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()
        lock.release()


    def save_sensors(self, dataSet):
        lock.acquire()
        """ insert a new dataSet into the log table """
        sql = """INSERT INTO "sensors" ("Timestamp", "Temperature", "Humidity", "SoilMoisture")
                VALUES (%s, %s, %s, %s);"""
        conn = None
        try:
            conn = psycopg2.connect(connStr)
            cur = conn.cursor()
            cur.execute(sql, (dataSet.Timestamp, dataSet.temperature, dataSet.humidity, dataSet.moisture))
            conn.commit()
            cur.close()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()
        lock.release()


    def get_last_entry(self) -> DataSet:
        lock.acquire()
        """ query latest dataSet from the sensor table """
        conn = None
        data = None
        try:
            conn = psycopg2.connect(connStr)
            cur = conn.cursor()
            cur.execute("""SELECT * FROM "sensors" WHERE "Counter" = (SELECT MAX("Counter") FROM "sensors");""")
            data = cur.fetchone()
            cur.close()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()
        lock.release()
        return DataSet(data[1], data[2], data[3], data[4])


    def get_all_entries(self) -> "list[DataSet]":
        lock.acquire()
        """ query all DataSets from the sensor table """
        conn = None
        data_list = []
        data = None
        try:
            conn = psycopg2.connect(connStr)
            cur = conn.cursor()
            cur.execute("""SELECT * FROM "sensors";""")
            data = cur.fetchall()
            cur.close()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

        for x in data:
            data_list.append(DataSet(x[1], x[2], x[3], x[4]))
        lock.release()
        return data_list


    def save_action(self):
        lock.acquire()
        now = datetime.now().strftime("%Y-%m-%d %H:%M")
        """ insert a new Timestamp into the  action table """
        sql = """INSERT INTO "actors" ("Timestamp")
                VALUES ( '%s' );"""
        conn = None
        try:
            conn = psycopg2.connect(connStr)
            cur = conn.cursor()
            cur.execute(sql %now)
            conn.commit()
            cur.close()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()
        lock.release()


    def get_all_actions(self) -> "list[str]":
        lock.acquire()
        """ query all Timestamps from the actors table """
        conn = None
        data_list = []
        data = None
        try:
            conn = psycopg2.connect(connStr)
            cur = conn.cursor()
            cur.execute("""SELECT * FROM "actors";""")
            data = cur.fetchall()
            cur.close()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

        for x in data:
            data_list.append(str(x[1]))
        lock.release()
        return data_list