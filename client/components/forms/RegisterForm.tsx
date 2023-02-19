"use client";
import { Formik, Form, Field } from "formik";
import React from "react";
import FormCard from "./FormCard";
import TextInput from "components/TextInput";
import Button from "components/Button";
import Checkbox from "components/Checkbox";
import TextLink from "components/TextLink";
import type { RegisterFormValues, RegisterErrorValues } from "types/form";

const RegisterForm: React.FC = () => {
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
      <FormCard label="Register">
        <Form className="flex w-full flex-col gap-6">
          <div className="flex flex-col justify-center gap-2">
            <div className="flex flex-col">
              <Field
                name="username"
                label="Username"
                type="text"
                placeholder="Username"
                component={TextInput}
              />
            </div>
            <div className="flex flex-col">
              <Field
                name="email"
                label="Email address"
                placeholder="Email"
                type="email"
                component={TextInput}
              />
            </div>
            <div className="flex gap-2">
              <div className="flex w-1/2 flex-col">
                <Field
                  name="password"
                  label="Password"
                  placeholder="Password"
                  type="password"
                  component={TextInput}
                />
              </div>
              <div className="flex w-1/2 flex-col">
                <Field
                  name="passwordConfirmation"
                  label="Confirm password"
                  placeholder="Confirm password"
                  type="password"
                  component={TextInput}
                />
              </div>
            </div>
          </div>

          <div className="ml-1 flex items-center justify-start gap-2">
            <Field
              component={Checkbox}
              name="rememberMe"
              label="Remember me"
              type="checkbox"
            />
          </div>

          <div className="h-10 w-full rounded-md bg-purple-500 transition-all hover:bg-purple-800">
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
          {/* <Link href={"/login"}>
            <span className="font-semibold text-purple-600 hover:underline">
              Log in
            </span>
          </Link> */}
          <TextLink value="Log in" href="/login" />
        </div>
      </FormCard>
    </Formik>
  );
};

export default RegisterForm;
