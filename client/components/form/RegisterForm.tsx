"use client";
import Link from "next/link";
import Button from "components/Button";
import { Field, Form, Formik } from "formik";
import InputField from "../InputField";

interface RegisterFormValues {
  username: string;
  email: string;
  password: string;
  passwordConfirmation: string;
}

export default function RegisterForm2() {
  const initialValues: RegisterFormValues = {
    username: "",
    email: "",
    password: "",
    passwordConfirmation: "",
  };
  return (
    <Formik
      initialValues={initialValues}
      onSubmit={(values) => alert(JSON.stringify(values, null, 2))}
    >
      <section className="flex min-h-screen items-center justify-center bg-white">
        <div className="flex flex-col items-center justify-center gap-6 rounded-2xl bg-cyan-200 p-4 shadow-sm shadow-cyan-400">
          <div className="flex w-full justify-center border-b border-solid border-gray-400 p-2 text-center">
            <span className="text-2xl font-medium">Register</span>
          </div>

          <Form className="flex w-full flex-col gap-6">
            <div className="flex flex-col justify-center gap-2">
              <div className="flex flex-col">
                <Field
                  name="username"
                  label="Username"
                  type="text"
                  placeholder="Username"
                  component={InputField}
                />
              </div>
              <div className="flex flex-col">
                <Field
                  name="email"
                  label="Email"
                  placeholder="Email"
                  type="email"
                  component={InputField}
                />
              </div>
              <div className="flex gap-2">
                <div className="flex flex-col">
                  <Field
                    name="password"
                    label="Password"
                    placeholder="Password"
                    type="password"
                    component={InputField}
                  />
                </div>
                <div className="flex flex-col">
                  <Field
                    name="confirmPassword"
                    label="Confirm password"
                    placeholder="Confirm password"
                    type="password"
                    component={InputField}
                  />
                </div>
              </div>
            </div>
            <div className="h-10 w-full rounded-md bg-green-600 transition-all hover:bg-green-700">
              <Button text="Sign Up" />
            </div>
          </Form>
          <div>
            Do you have an account already?{" "}
            <Link href={"/login"}>
              <span className="font-semibold text-purple-600">Log in</span>
            </Link>
          </div>
        </div>
      </section>
    </Formik>
  );
}
