#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

#define MAX_DATA 512
#define MAX_ROWS 100
typedef struct Address {
	int id;
	int set;
	char name[MAX_DATA];
	char email[MAX_DATA];
} Address;

typedef struct Database {
	Address rows[MAX_ROWS];
} Database;

typedef struct Connection {
	FILE *file;
	Database *db;
} Connection;

void die(const char *message) {
	if(errno) {
		perror(message);
	}
	else {
		printf("ERROR: %s\n", message);
	}
	exit(1);
}

void Database_load(Connection *conn) {
	int cnt = fread(conn->db, sizeof(Database), 1, conn->file);
}

Connection *Database_open(char *filename, char mode) {
	Connection *conn = malloc(sizeof(Connection));
	printf("Connection belong size %d(16) bytes\n", sizeof(Connection));

	conn->db = malloc(sizeof(Database));
	if(mode == 'c') {
		conn->file = fopen(filename, "w");
	}
	else {
		conn->file = fopen(filename, "r+");
		if(!conn->file) {
			die("Fail to open the file!");
		}
		else {
			Database_load(conn);
		}
	}
	return conn;
}

void Database_create(Connection *conn) {
	for(int i = 0; i < MAX_ROWS; i ++) {
		Address addr = {.id = i, .set = 0};
		conn->db->rows[i] = addr;
	}
}

void Database_write(Connection *conn) {
	rewind(conn->file);

	int cnt = fwrite(conn->db, sizeof(Database), 1, conn->file);
	cnt = fflush(conn->file);
}

void show(Address *addr) {
	if(addr->set == 0) return ;
	printf("%d %s %s\n", addr->id, addr->name, addr->email);
}

void Database_get(Connection *conn, int id) {
	Address *addr = &conn->db->rows[id];

    if(addr->set) {
        show(addr);
    } else {
        die("ID is not set");
    }
}

void Database_set(Connection *conn, int id, char *name, char *email) {
	Address *addr = &conn->db->rows[id];
    if(addr->set) die("Already set, delete it first");

    addr->set = 1;
    // WARNING: bug, read the "How To Break It" and fix this
    char *res = strncpy(addr->name, name, MAX_DATA);
    // demonstrate the strncpy bug
    if(!res) die("Name copy failed");

    res = strncpy(addr->email, email, MAX_DATA);
    if(!res) die("Email copy failed");
}

void Database_delete(Connection *conn, int id) {
	Address addr = {.id = id, .set = 0};
	conn->db->rows[id] = addr;
}

void Database_list(Connection *conn) {
	for(int i = 0; i < MAX_ROWS; i ++) {
		show(conn->db->rows + i);
	}
}

void Database_close(Connection *conn) {
	if(conn) {
		fclose(conn->file);
		free(conn->db);
		free(conn);
	}
}

int main(int argc, char *argv[]) {
	if(argc < 3) die("USAGE: ex17 <dbfile> <action> [action params]");

	char *filename = argv[1];
	char mode = argv[2][0];
	// In this way, we have a data struct which name is Connection.
	// The Connection read a file and save the data in database.
	// In other word, Connection is a bridge from file point to database.
	Connection *conn = Database_open(filename, mode);	

	int id = 0;
	// atoi: convert string to int
	if(argc > 3) id = atoi(argv[3]);
    if(id >= MAX_ROWS) die("There's not that many records.");

	switch(mode) {
        case 'c':
            Database_create(conn);
            Database_write(conn);
            break;

        case 'g':
            if(argc != 4) die("Need an id to get");

            Database_get(conn, id);
            break;

        case 's':
            if(argc != 6) die("Need id, name, email to set");

            Database_set(conn, id, argv[4], argv[5]);
            Database_write(conn);
            break;

        case 'd':
            if(argc != 4) die("Need id to delete");

            Database_delete(conn, id);
            Database_write(conn);
            break;

        case 'l':
            Database_list(conn);
            break;
        default:
            die("Invalid action, only: c=create, g=get, s=set, d=del, l=list");
    }

    // Database_close(conn);

	return 0;
}
