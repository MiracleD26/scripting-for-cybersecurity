def student_info(student_name, student_id, module_name="Scripting for Cyber"):
    print("Name:", student_name)
    print("ID:", student_id)
    print("Module:", module_name)

# Call with name and student id
student_info("Miracle Duru", "c00260985")

# Pass student id first using keyword arguments
student_info(student_id="c00260985", student_name="Miracle Duru")