"use client";
import Link from "next/link";
import Button from "components/Button";
import { Field, Form, Formik } from "formik";
import InputField from "components/InputField";
import type { RegisterFormValues, RegisterErrorValues } from "types/form";

// TODO: Make this play with the server's API
// same with ./LoginForm.tsx

export default function RegisterForm() {
  const initialValues: RegisterFormValues = {
    username: "",
    email: "",
    password: "",
    passwordConfirmation: "",
  };
  const validateRequired = (values: RegisterFormValues) => {
    const errors: RegisterErrorValues = {} as RegisterErrorValues;

    if (!values.username) {
      errors.username = "Field is required";
    }
    if (!values.email) {
      errors.email = "Field is required";
    }
    if (!values.password) {
      errors.password = "Field is required";
    }
    if (!values.passwordConfirmation) {
      errors.passwordConfirmation = "Field is required";
    }

    return errors;
  };
  return (
    <Formik
      initialValues={initialValues}
      validate={validateRequired}
      onSubmit={(values: RegisterFormValues) =>
        alert(JSON.stringify(values, null, 2))
      }
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
                    name="passwordConfirmation"
                    label="Confirm password"
                    placeholder="Confirm password"
                    type="password"
                    component={InputField}
                  />
                </div>
              </div>
            </div>
            <div className="h-10 w-full rounded-md bg-green-600 transition-all hover:bg-green-700">
              <Button
                className="h-full w-full font-bold text-white"
                value="Sign up"
                handleClick={() => null}
                type="submit"
              />
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
