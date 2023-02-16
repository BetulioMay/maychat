"use client";
import { LoginFormValues, LoginErrorValues } from "types/form";
import { Field, Form, Formik } from "formik";
import Link from "next/link";
import Button from "../Button";
import TextInput from "../TextInput";
import Checkbox from "../Checkbox";

export default function LoginForm() {
  const initialValues: LoginFormValues = {
    usernameOrEmail: "",
    password: "",
  };
  const validateRequired = (values: LoginFormValues) => {
    const errors: LoginErrorValues = {} as LoginErrorValues;

    if (!values.usernameOrEmail) {
      errors.usernameOrEmail = "Field is required";
    }

    if (!values.password) {
      errors.password = "Field is required";
    }

    return errors;
  };
  return (
    <Formik
      initialValues={initialValues}
      validate={validateRequired}
      onSubmit={(values: LoginFormValues) =>
        alert(JSON.stringify(values, null, 2))
      }
    >
      <section className="flex min-h-screen items-center justify-center bg-white">
        <div className="flex w-1/4 flex-col items-center justify-center gap-6 rounded-2xl bg-cyan-200 p-4 shadow-sm shadow-cyan-400">
          <div className="flex w-full justify-center border-b border-solid border-gray-400 p-2 text-center">
            <span className="text-2xl font-medium">Log in</span>
          </div>

          <Form className="flex w-full flex-col gap-6">
            <div className="flex w-full flex-col justify-center gap-2">
              <div className="flex flex-col">
                <Field
                  name="usernameOrEmail"
                  label="Username or email"
                  type="text"
                  placeholder="Username or email"
                  component={TextInput}
                />
              </div>
              <div className="flex flex-col">
                <Field
                  name="password"
                  label="Password"
                  type="password"
                  placeholder="Password"
                  component={TextInput}
                />
              </div>
            </div>
            <div className="ml-1 flex items-center justify-start gap-2">
              <Field
                name="rememberMe"
                label="Remember me"
                type="checkbox"
                component={Checkbox}
              />
            </div>

            <div className="h-10 w-full rounded-md bg-purple-500 transition-all hover:bg-purple-800">
              <Button
                className="h-full w-full font-bold text-white"
                value="Log in"
                handleClick={() => console.log("ello")}
                type="submit"
              />
            </div>
          </Form>
          <div>
            Not a member?{" "}
            <Link href={"/register"}>
              <span className="font-semibold text-purple-600">Sign up</span>
            </Link>
          </div>
        </div>
      </section>
    </Formik>
  );
}
