import clips
from tkinter import *
from PIL import Image, ImageTk

def load_properties(prop):
    with open('env.properties', 'r') as file:
        for line in file:
            name, full_name = line.strip().split('=')
            prop[name] = full_name

def get_property(name):
    return properties.get(name, "")

def get_slot():
    return str(clips_env.eval('(find-all-facts ((?f state-list)) TRUE)')[0]['current'])

def get_interface():
    return clips_env.eval(f'(find-all-facts ((?f Interface)) (eq ?f:slot {get_slot()}))')[0]

def update_question():
    question_text.set(get_property(get_interface()['show']))

def update_answers():
    books = get_interface()['books']
    num_books = len(books)
    start_column = (4 - num_books) // 2

    for i, text in enumerate(answer_texts):
        if i < num_books:
            text.set(get_property(str(books[i])))
            answer_labels[i].grid(row=2, column=start_column + i, padx=10, pady=10)
        else:
            answer_labels[i].grid_forget()

def update_buttons():
    answers = get_interface()['answers']
    num_answers = len(answers)
    start_column = (4 - num_answers) // 2

    for i, text in enumerate(button_texts):
        if i < num_answers:
            text.set(get_property(str(answers[i])))
            buttons[i].grid(row=3, column=start_column + i, padx=10, pady=10)
        else:
            buttons[i].grid_forget()

def button_command(answer_idx):
    answers = get_interface()['answers']
    clips_env._facts.assert_string(f'(next {get_slot()} {answers[answer_idx]})')
    clips_env._agenda.run()
    refresh_interface(False)

def restart():
    clips_env.reset()
    clips_env._agenda.run()
    refresh_interface(True)

def toggle_state():
    state = str(get_interface()['state'])
    if state == 'begin':
        clips_env._facts.assert_string(f'(next {get_slot()})')
    elif state in ['middle', 'end']:
        clips_env._facts.assert_string(f'(previous {get_slot()})')
    clips_env._agenda.run()
    refresh_interface(False)

def refresh_interface(initial):
    state = str(get_interface()['state'])
    func_button_text.set('Start' if state == 'begin' else 'Back')
    update_question()
    if initial:
        for label in answer_labels:
            label.grid_forget()
    update_buttons()
    if state == 'end':
        update_answers()
    else:
        for label in answer_labels:
            label.grid_forget()

if __name__ == '__main__':
    root = Tk()
    root.geometry('900x600')
    root.title('Best Book of the 21st Century')

    # Load and process the background image
    image = Image.open('123.png')
    dark_overlay = Image.new('RGBA', image.size, (0, 0, 0, 128))  # 128 is the alpha value for 50% opacity
    combined = Image.alpha_composite(image.convert('RGBA'), dark_overlay)
    img = ImageTk.PhotoImage(combined)

    background_label = Label(root, image=img)
    background_label.place(relwidth=1, relheight=1)

    clips_env = clips.Environment()
    clips_env.load('clips.CLP')
    clips_env.reset()
    clips_env._agenda.run()

    properties = {}
    load_properties(properties)
    func_button_text = StringVar(value='Start')
    restart_button_text = StringVar(value='Restart')
    question_text = StringVar()
    button_texts = [StringVar() for _ in range(20)]
    answer_texts = [StringVar() for _ in range(20)]
    buttons = [Button(root, textvariable=text, width=15, command=lambda i=i: button_command(i))
               for i, text in enumerate(button_texts)]
    answer_labels = [Label(root, textvariable=text, bg='#F5F5DC', font='Arial 12 bold')
                     for i, text in enumerate(answer_texts)]

    # Updated question label with new font and color
    question_label = Label(root, textvariable=question_text, bg='#1E3A5F', fg='#E0E0E0',
                           font='Helvetica 24 bold italic', pady=20, padx=20, relief=GROOVE, borderwidth=2)
    question_label.grid(row=0, column=0, columnspan=4, pady=20)

    # Adjusted size of function and restart buttons
    func_button = Button(root, textvariable=func_button_text, width=15, padx=5, pady=5, command=toggle_state,
                         borderwidth=3, activebackground='#cfbb69', bg='#4CAF50', fg='#FFFFFF', font='Arial 14 bold',
                         relief=RAISED)
    func_button.grid(row=5, column=0, columnspan=2, padx=5, pady=5, sticky=W)

    restart_button = Button(root, textvariable=restart_button_text, width=15, padx=5, pady=5, command=restart,
                            borderwidth=3, activebackground='#cfbb69', bg='#F44336', fg='#FFFFFF', font='Arial 14 bold',
                            relief=RAISED)
    restart_button.grid(row=5, column=2, columnspan=2, padx=5, pady=5, sticky=E)

    for button in buttons:
        button.grid(row=3, column=buttons.index(button), padx=10, pady=10)
    for label in answer_labels:
        label.grid(row=2, column=answer_labels.index(label), padx=10, pady=10)

    # Configure grid layout to ensure centering
    for i in range(4):
        root.grid_columnconfigure(i, weight=1)
    root.grid_rowconfigure(0, weight=1)
    root.grid_rowconfigure(1, weight=1)
    root.grid_rowconfigure(2, weight=1)
    root.grid_rowconfigure(3, weight=1)
    root.grid_rowconfigure(4, weight=1)
    root.grid_rowconfigure(5, weight=1)

    refresh_interface(True)
    root.mainloop()