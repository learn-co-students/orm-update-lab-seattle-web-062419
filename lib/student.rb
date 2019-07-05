require_relative "../config/environment.rb"
require 'pry'

class Student

  # attr_accessor :name, :grade
  # attr_reader :id

  # def initialize(id=nil, name, grade)
  #   @id = id
  #   @name = name
  #   @grade = grade
  # end

  # def self.create_table
  #   sql = <<-SQL
  #     CREATE TABLE IF NOT EXISTS students (
  #       id INTEGER PRIMARY KEY,
  #       name TEXT,
  #       grade TEXT
  #     );
  #     SQL

  #   DB[:conn].execute(sql)
  # end

  # def self.drop_table
  #   sql = <<-SQL
  #     DROP TABLE students;
  #     SQL

  #   DB[:conn].execute(sql)
  # end

  # def update
  #   sql = <<-SQL
  #     UPDATE students
  #     SET name = ?, grade = ?
  #     WHERE id = ?;
  #     SQL

  #   DB[:conn].execute(sql, self.name, self.grade, self.id)[0][0]
  # end

  # def save
    
  #   if self.id
  #     self.update
  #   else
  #     sql = <<-SQL
  #       INSERT INTO students (name, grade)
  #       VALUES (?, ?);
  #       SQL
  #   end

  #     DB[:conn].execute(sql, self.name, self.grade)
  #     @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  # end

  # def create(name, grade)
  #   student = Student.new(name, grade)

  #   student.save
  # end

  # def self.new_from_db

  # end

  # def self.find_by_name(name)
  #   sql = <<-SQL
  #       SELECT *
  #       FROM students
  #       WHERE name = ?;
  #       SQL

  #   DB[:conn].execute(sql, name)
  # end

  attr_accessor :id, :name, :grade

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      );
      SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students;
      SQL

    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?);
        SQL

        DB[:conn].execute(sql, self.name, self.grade)
        self.id = DB[:conn].execute("SELECT id FROM students ORDER BY id DESC LIMIT 1")[0][0]
    end
  end

  def update
    sql = <<-SQL
        UPDATE students
        SET name = ?, grade = ?
        WHERE id = ?;
        SQL

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def self.create(name, grade)
    ns = Student.new(name, grade)
    ns.save
  end

  def self.new_from_db(array)
    ns = Student.new(array[0], array[1], array[2])
    ns.save
    ns
  end

  def self.find_by_name(name)
    sql = <<-SQL
        SELECT *
        FROM students
        WHERE name = ?;
        SQL
        
    ret = DB[:conn].execute(sql, name)
    self.new_from_db(ret.first)
  end


  # helper method(s)
  def self.view_db
    DB[:conn].execute("SELECT * FROM students")
  end
end
