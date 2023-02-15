"use client";
import { FieldProps } from "formik";
import {
  DetailedHTMLProps,
  InputHTMLAttributes,
  LabelHTMLAttributes,
} from "react";

type InputProps = DetailedHTMLProps<
  LabelHTMLAttributes<HTMLLabelElement>,
  HTMLLabelElement
> &
  DetailedHTMLProps<InputHTMLAttributes<HTMLInputElement>, HTMLInputElement>;

interface OtherProps {
  label: string;
}

const InputField = ({
  label,
  form: { touched, errors },
  field,
  ...props
}: FieldProps & InputProps & OtherProps) => {
  const error = touched[field.name] && errors[field.name];
  return (
    <>
      <label className="m-2" htmlFor={props.name}>
        {label}
      </label>
      <input className="rounded-xl p-2 shadow-md" {...field} {...props} />
      {error ? (
        <div className="font-thin text-red-600">
          {errors[field.name] as string}
        </div>
      ) : null}
    </>
  );
};

export default InputField;
