import psycopg2
import psycopg2.extras

# Tutorial
# https://www.youtube.com/watch?v=M2NzvnfS-hI&t=281s&ab_channel=techTFQ

server = 'localhost'
database = 'postgres'
port_id = '5432'
pwd = ''
username = 'postgres'

conn = None
cur = None

try:
    conn = psycopg2.connect(
        host=server,
        dbname=database,
        user=username,
        password=pwd,
        port=port_id
    )

    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)

    cur.execute('DROP TABLE IF EXISTS employee')
    create_script = ''' CREATE TABLE IF NOT EXISTS employee (
        id int PRIMARY KEY,
        name varchar(40) NOT NULL,
        salary int,
        dept_id varchar(30)
    );'''

    cur.execute(create_script)

    insert_script = '''INSERT INTO employee (id, name, salary, dept_id) VALUES (%s, %s, %s, %s)'''
    insert_values = [(1, 'James', 12000, 'D1'), (2, 'Bravo', 20000, 'D1'), (3, 'Charlie', 5000, 'E1')]

    for record in insert_values:
        cur.execute(insert_script, record)

    # UPDATING DATA
    update_script = 'UPDATE employee SET salary = salary + (salary * 0.5)'
    cur.execute(update_script)

    # DELETING DATA
    delete_script = 'DELETE FROM employee WHERE name = %s'
    delete_record = ('James',)
    cur.execute(delete_script, delete_record)

    cur.execute('SELECT * FROM employee')
    for record in cur.fetchall():
        # print(record[1], record[2])
        print(record['name'], record['salary'])

    conn.commit()
except Exception as error:
    print(error)
finally:
    if cur:
        cur.close()
    if conn:
        conn.close()
